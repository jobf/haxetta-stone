import dials.Disk;
import dials.SettingsController;
import lime.utils.AssetType;
import lime.utils.Assets;
import Editor;
import Models;
import GraphicsAbstract;
import Controller;
import InputAbstract;
import Engine;
import Disk;

using Vector;



class LunarScene extends Scene {
	var model_translation:EditorTranslation;
	var model_index:Int = 0;
	var file:FileModel;
	var x:Float = 0;
	var y:Float = 0;

	var drawing:Drawing;

	public function init() {
		x = bounds.width * 0.5;
		y = bounds.height * 0.5;
		// game.input.mouse_cursor_hide();
		model_translation = new EditorTranslation({
			y: 0,
			x: 0,
			width: 64,
			height: 64
		}, 1, 1);
		for (s in Assets.list(AssetType.TEXT)) {
			trace(s);
		}
		var models_json = Assets.getText('assets/alphabet-01.json');

		file = Disk.parse_file_contents(models_json);

		var actions:Map<Button, Action> = [
			KEY_LEFT => {
				on_pressed: () -> {
					var next = model_index - 1;
					model_index = (next % file.models.length + file.models.length) % file.models.length;
					draw_model();
				}
			},
			KEY_RIGHT => {
				on_pressed: () -> {
					var next = model_index + 1;
					model_index = (next % file.models.length + file.models.length) % file.models.length;
					draw_model();
				}
			}
		];

		game.input.on_pressed = button -> {
			if (actions.exists(button)) {
				actions[button].on_pressed();
			}
		}

		game.input.on_released = button -> {
			if (actions.exists(button)) {
				actions[button].on_released();
			}
		}

		draw_model();

	
		settings_bind();

	}


	function settings_bind(){
		var page:Page = {
			pads: [],
			name: "one",
		}

		var settings = new SettingsController(new DiskSys());
		settings.page_add(page);
		
		var g:Graphics = cast game.graphics;
		@:privateAccess
		var display = g.display;
		display.zoom = 1.0;
		display.xOffset = 0;
		display.yOffset = 0;


		settings.pad_add({
			name: "camera",
			index_palette: 1,
			// index: index,
			encoders: [
				VOLUME => {
					value: display.xOffset,
					on_change: f -> display.xOffset = f,
					name: "x offset",
					minimum: -100000,
					maximum: 100000,
					increment: 10
				},
				PAN => {
					value: display.yOffset,
					on_change: f -> display.yOffset = f,
					name: "y offset",
					minimum: -100000,
					maximum: 100000,
					increment: 10
				},
				// FILTER => {
				// 	value: entity.scale,
				// 	on_change: f -> entity.scale = Std.int(f),
				// 	name: "scale",
				// 	// increment: 0.1,
				// 	minimum: 0.001
				// },
				RESONANCE => {
					value: display.zoom,
					on_change: f -> display.zoom = f,
					name: "zoom",
					minimum: 0.1,
					increment: 0.01
				}
			]
		}, page.index);

		settings.pad_add({
			name: "figure",
			index_palette: 0,
			// index: index,
			encoders: [
				VOLUME => {
					value: drawing.origin.y,
					on_change: f -> drawing.origin.y = f,
					name: "y origin ",
					increment: 0.01,
					minimum: -10000,
					maximum: 10000
				},
				PAN => {
					value: drawing.rotation,
					on_change: f -> drawing.rotation = f,
					name: "rotation",
					increment: 0.01,
					minimum: -360,
					maximum: 360
				},
				// FILTER => {
				// 	value: entity.scale,
				// 	on_change: f -> entity.scale = f,
				// 	name: "scale",
				// 	// increment: 0.1,
				// 	minimum: 0.00001
				// },
				// RESONANCE => {
				// 	value: entity.rotation,
				// 	on_change: f -> entity.rotation = f,
				// 	name: "angle",
				// 	increment: 0.1,
				// 	minimum: -360
				// }
			]
		}, page.index);
	}

	function draw_model(){
		drawing = new Drawing({
			figure: file.models[model_index]
		},
		x,
		y,
		game.graphics,
		model_translation);
	}

	public function update(elapsed_seconds:Float) {
	
		drawing.draw();
	}

	public function draw() {
	}

}

@:structInit
class Prototype{
	public var figure:FigureModel;
}

class Drawing{
	var model:Prototype;
	var model_translation:EditorTranslation;
	public var origin:Vector = {
		x:-0.5,
		y:-0.5
	};
	public var x:Float = 0;
	public var y:Float = 0;
	public var scale:Float = 1;
	public var rotation:Float = 0;

	var lines:Array<AbstractLine> = [];
	public function new(model:Prototype, x:Float, y:Float, graphics:GraphicsAbstract, model_translation:EditorTranslation) {
		this.x = x;
		this.y = y;
		this.model = model;
		this.model_translation = model_translation;
		for (proto in model.figure.lines) {
			var line =  graphics.make_line(0,0,1,1, 0x2C8D49ff);
			lines.push(line);
		}
	}

	function translate(line_proto:LineModel, line_drawing:AbstractLine, rotation_sin:Float, rotation_cos:Float){
		var from_:Vector ={
			x: line_proto.from.x + origin.x,
			y: line_proto.from.y + origin.y
		}
		var to_:Vector = {
			x: line_proto.to.x + origin.x,
			y: line_proto.to.y + origin.y
		}
		var from = model_translation.model_to_view_point(from_).vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
		var to = model_translation.model_to_view_point(to_).vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
		line_drawing.point_from.x = from.x - (origin.y * scale);
		line_drawing.point_from.y = from.y - (origin.y * scale);
		line_drawing.point_to.x = to.x - (origin.x * scale);
		line_drawing.point_to.y = to.y - (origin.y * scale);
	}

	public function draw(){
		var rotation_sin = Math.sin(rotation);
		var rotation_cos = Math.cos(rotation);
		for (n => proto in model.figure.lines) {
			translate(proto, lines[n], rotation_sin, rotation_cos);
		}
	}
}