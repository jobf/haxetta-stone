import Graphics;
import peote.view.PeoteView;
import peote.view.Display;
import automation.Oscillator;
import automation.Envelope;
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
	var wheel:Wheel;

	var countdown_cheese_release:CountDown;
	var performer:Performer;
	var controller:Controller;
	var display:Display;
	var peoteview:PeoteView;
	var hud:Hud;


	public function init() {
		var g:Graphics = cast game.graphics;
		@:privateAccess
		display = g.display;
		@:privateAccess
		peoteview = g.peoteview;

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

		hud = new Hud(peoteview, {
			y: 0,
			x: 0,
			width: bounds.width,
			height: Std.int(bounds.height * 0.25)
		}, file.models, model_translation);
		// hud.write_message("HELLO 0001");

		draw_bot();
		performer = new Performer(drawing);

		wheel = new Wheel();
		countdown_cheese_release = new CountDown(0.9, () -> {
			// var i = randomInt(2,20);
			wheel.create(x, y, file.models[0], model_translation, game.graphics);
		}, true);

		settings_bind();

		var actions:Map<Button, Action> = [
			MOUSE_LEFT => {
				on_pressed: () -> {
					performer.press();
				},
				on_released: () -> {
					performer.release();
				}
			},
			KEY_C => {
				on_pressed: () -> {
					wheel.create(x, y, file.models[0], model_translation, game.graphics);
				}
			},
		];


		controller = new Controller(actions, game.input);
		game.input.on_pressed = button -> controller.handle_button(PRESSED, button);
		game.input.on_released = button -> controller.handle_button(RELEASED, button);
	}

	function draw_bot(){
		drawing = new Drawing({
			figure: file.models[model_index]
		},
		x,
		y,
		game.graphics.make_line,
		model_translation);
	}

	public function update(elapsed_seconds:Float) {
		countdown_cheese_release.update(elapsed_seconds);
		performer.update(elapsed_seconds);
		wheel.update(elapsed_seconds);
		// drawing.draw
		var overlaps = wheel.overlaps_a_line(drawing.lines);
		for (cheese in overlaps) {
			wheel.remove(cheese);
			hud.score_change(10);
			// final red:Int = 0xFF0000ff;
			// final white:Int = 0xFFFFFFff;
			// bot.entity.set_color(overlaps ? red : white);
		}
	}
	
	public function draw() {
		drawing.draw();
		hud.draw();
	}


	function settings_bind(){
		var page:Page = {
			pads: [],
			name: "one",
		}

		var settings = new SettingsController(new DiskSys());
		// settings.disk_load();
		settings.page_add(page);
		

		display.zoom = 1.0;
		display.xOffset = 0;
		display.yOffset = 0;


		settings.pad_add({
			name: "camera",
			index_palette: 0,
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
			index_palette: 1,
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
				FILTER => {
					value: drawing.scale,
					on_change: f -> drawing.scale = f,
					name: "scale",
					increment: 0.01,
					minimum: 0.00001
				},
				// RESONANCE => {
				// 	value: entity.rotation,
				// 	on_change: f -> entity.rotation = f,
				// 	name: "angle",
				// 	increment: 0.1,
				// 	minimum: -360
				// }
			]
		}, page.index);

		settings.pad_add({
			name: "wheel",
			index_palette: 2,
			// index: index,
			encoders: [
				VOLUME => {
					value: wheel.y_origin,
					on_change: f -> wheel.y_origin = f,
					name: "w y origin ",
					increment: 0.01,
					minimum: -10000,
					maximum: 10000
				},
				// PAN => {
				// 	value: wheel.rotation_speed,
				// 	on_change: f -> wheel.rotation_speed = f,
				// 	name: "speed",
				// 	increment: 0.01,
				// 	minimum: -10,
				// 	// maximum: 1
				// },
				FILTER => {
					value: wheel.scale,
					on_change: f -> wheel.scale = f,
					name: "w scale",
					increment: 0.1,
					minimum: 0.00001
				},
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
	public var rotation_speed:Float = -0.01;
	public var rotation_direction:Int = 0;


	public var lines:Array<AbstractLine> = [];
	public function new(model:Prototype, x:Float, y:Float, make_line:MakeLine, model_translation:EditorTranslation) {
		this.x = x;
		this.y = y;
		this.model = model;
		this.model_translation = model_translation;
		for (proto in model.figure.lines) {
			var line =  make_line(0,0,1,1, 0x2C8D49ff);
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
		rotation = rotation + (rotation_speed * rotation_direction);

		var rotation_sin = Math.sin(rotation);
		var rotation_cos = Math.cos(rotation);
		for (n => proto in model.figure.lines) {
			translate(proto, lines[n], rotation_sin, rotation_cos);
		}
	}
}


class Wheel {
	var drawings:Array<Drawing>;
	var model_translation:EditorTranslation;
	public var rotation_speed:Float = 0.018;
	public var rotation_init:Float = 0;
	// public var rotation_direction:Int = -1;
	public var y_origin:Float = -2;
	public var scale:Float = 1;
	public var overlap:Float = 5;
	var x:Float;
	var y:Float;




	public function new() {
		drawings = [];
	}

	public function create(x, y, model:FigureModel, model_translation:EditorTranslation, graphics:GraphicsAbstract):Drawing {
		// trace('new drawin');
		this.x = x;
		this.y = y;
		this.model_translation = model_translation;
		var drawing = new Drawing({
			figure: model,
		}, x, y, graphics.make_line, model_translation);
		// drawing.rotation
		@:privateAccess
		drawing.origin.y = y_origin;
		drawing.scale = scale;
		drawing.rotation = rotation_init;
		drawing.rotation_speed = rotation_speed;
		drawing.rotation_direction = -1;
		drawings.push(drawing);
		return drawing;
	}

	public function overlaps(target:Vector):Array<Drawing> {
		var matching = drawings.filter(shape -> target.point_overlaps_circle({
			y: shape.y,
			x: shape.x
		}, overlap));
		return matching;
	}

	public function overlaps_a_line(target_lines:Array<AbstractLine>):Array<Drawing> {
		var collides:(target:AbstractLine, lines:Array<AbstractLine>) -> Bool = (target:AbstractLine, lines:Array<AbstractLine>) -> {
			var collide = false;
			for(l in lines){
				if(VectorLogic.line_overlaps_line(target.point_from, target.point_to, l.point_from, l.point_to)){
					collide = true;
					break;
				}
			}
			return collide;
		}

		for (line in target_lines) {
			var matching = drawings.filter(shape -> collides(line, shape.lines));
			if(matching.length > 0){
				return matching;
			}
		}

		return [];
	}


	public function remove(drawing:Drawing) {
		if (drawings.contains(drawing)) {
			for (line in drawing.lines) {
				line.erase();
			}
			drawings.remove(drawing);
		}
	}

	public function update(elapsed_seconds:Float) {

		// rotation = rotation + (rotation_speed * rotation_direction);
		for (drawing in drawings) {
			// drawing.x = x;
			// drawing.y = y;
			drawing.origin.y = y_origin;
			// drawing.rotation = rotation;
			// drawing.rotation_speed = rotation_speed;
			drawing.scale = scale;
			drawing.draw();
		}
	}

	public function draw() {
		// for (drawing in drawings) {
		// 	drawing.draw();
		// }
	}
}


class Performer {
	public var envelope:Envelope;
	public var lfo:LFO;
	public var graphic:Drawing;
	public var jump_height:Float = -1.5;
	public var y_wobble:Float = 0.01;

	var x:Float;
	public var y:Float;
	var oscillate_y:Float;

	public function new(graphic:Drawing) {
		this.graphic = graphic;
		this.x = graphic.x;
		this.y = graphic.origin.y;
		var framesPerSecond = 60;
		envelope = new Envelope(framesPerSecond);
		var wavetable = new WaveTable(framesPerSecond);
		envelope.releaseTime = 0.3;
		lfo = {
			shape: SINE,
			sampleRate: framesPerSecond,
			frequency: 1,
			oscillator: wavetable
		};
		lfo.shape = SINE;
	}

	public function update(elapsed:Float) {
		var amp_jump = envelope.nextAmplitude();
		var amp_wobble = lfo.next();
		var jump = -(jump_height * amp_jump);
		var wobble = amp_wobble * y_wobble;
		graphic.origin.y = y + jump + wobble;
	}

	public function draw() {
		// graphic.draw();
	}

	public function press() {
		envelope.open();
	}

	public function release() {
		envelope.close();
	}
}
