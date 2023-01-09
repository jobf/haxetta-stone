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

class ModelTestScene extends Scene {
	var model_translation:EditorTranslation;
	var model_index:Int = 0;
	var file:FileModel;
	var lines:Array<AbstractLine> = [];
	var origin:Vector = {
		x:-0.5,
		y:-0.5
	};
	var x:Float = 0;
	var y:Float = 0;
	var scale:Float = 2;

	var  settings:SettingsController;
	var rotation:Float = 0;
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

	

		var page:Page = {
			pads: [],
			name: "one",
		}

		settings = new SettingsController(new DiskSys());
		settings.page_add(page);
		

		var g:Graphics = cast game.graphics;
		@:privateAccess
		var display = g.display;
		display.zoom = 1.16;
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
					value: origin.y,
					on_change: f -> origin.y = f,
					name: "y origin ",
					increment: 0.01,
					minimum: -10000,
					maximum: 10000
				},
				PAN => {
					value: rotation,
					on_change: f -> rotation = f,
					name: "rotation",
					increment: 0.01,
					minimum: -360,
					maximum: 360
				},
				FILTER => {
					value: scale,
					on_change: f -> scale = f,
					name: "scale",
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

	function draw_model(){
		var i = lines.length;
		while (i-- > 0) {
			lines[i].erase();
			lines.remove(lines[i]);
		}
		var char = file.models[model_index];
		trace('draw index $model_index');
		var rotation_sin = Math.sin(rotation);
		var rotation_cos = Math.cos(rotation);
		for (line in char.lines) {
			var from_:Vector ={
				x: line.from.x + origin.x,
				y: line.from.y + origin.y
			}
			var to_:Vector = {
				x: line.to.x + origin.x,
				y: line.to.y + origin.y
			}
			var from = model_translation.model_to_view_point(from_).vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
			var to = model_translation.model_to_view_point(to_).vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
			var _line = game.graphics.make_line(from.x, from.y, to.x, to.y, 0x2C8D49ff);
			// trace('translated line ${_line.point_from.x},${_line.point_from.y} -> ${_line.point_to.x},${_line.point_to.y}');
			lines.push(_line);
		}
	}

	public function update(elapsed_seconds:Float) {
		// var figure = file.models[model_index];
		// // for (line in lines) {
		// // 	line.
		// // }		
		// var rotation_sin = Math.sin(rotation);
		// var rotation_cos = Math.cos(rotation);
		// for (n => line in lines) {
		// 	var line_model = figure.lines[n];
		// 	line.color = color;
		// 	line.point_from = line_model.from.vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
		// 	line.point_to = line_model.to.vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
		// 	// line.draw();
		// }

		var char = file.models[model_index];

		var rotation_sin = Math.sin(rotation);
		var rotation_cos = Math.cos(rotation);
		var scale_origin:Vector = {
			y: scale/origin.y,
			x: scale/origin.x
		}
		var model_origin = model_translation.view_to_model_point(scale_origin);


		for (n => line in char.lines) {
			var from_:Vector ={
				x: line.from.x + model_origin.x,
				y: line.from.y + model_origin.y
			}
			var to_:Vector = {
				x: line.to.x + model_origin.x,
				y: line.to.y + model_origin.y
			}
			var from = model_translation.model_to_view_point(from_).vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
			var to = model_translation.model_to_view_point(to_).vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
			lines[n].point_from.x = from.x - (origin.y * scale);
			lines[n].point_from.y = from.y - (origin.y * scale);
			lines[n].point_to.x = to.x - (origin.x * scale);
			lines[n].point_to.y = to.y - (origin.y * scale);
			// trace('translated line ${_line.point_from.x},${_line.point_from.y} -> ${_line.point_to.x},${_line.point_to.y}');
			// lines.push(_line);
		}
	}

	public function draw() {
	}

}
