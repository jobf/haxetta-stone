import Asteroid;
import lime.utils.Assets;
import Disk;
import Controller;
import Editor;
import dials.Disk;
import dials.SettingsController;
import InputAbstract;
import Engine;
import Models;

using Vector;

class SpaceScene extends Scene {
	var bot:Shape;
	// var cheese:Shape;

	var x_center:Int;
	var y_center:Int;

	var controller:Controller;
	var settings:SettingsController;
	var file:FileModel;
	var model_translation:EditorTranslation;
	var cheeseWheel:CheeseWheel;

	public function init() {
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);
		var models_json = Assets.getText('assets/alphabet-01.json');

		file = Disk.parse_file_contents(models_json);

		model_translation = new EditorTranslation(bounds, 1, 1);

		settings = new SettingsController(new DiskSys());
		bot = new Shape(x_center, y_center, game.graphics, file.models[0], model_translation);
		bot.entity.scale = 20;
		bot.entity.rotation = -3.8;
		bot.entity.set_rotation_direction(0);
		// bot.set_rotation_direction(1);

		@:privateAccess
		bot.entity.lines.origin.y = 0.7;
		bot.entity.scale = 218;

		// cheese_spawn();

		var actions:Map<Button, Action> = [
			// KEY_LEFT => {
			// 	on_pressed: () -> bot.set_rotation_direction(-1),
			// 	on_released: () -> bot.set_rotation_direction(0)
			// },
			// KEY_RIGHT => {
			// 	on_pressed: () -> bot.set_rotation_direction(1),
			// 	on_released: () -> bot.set_rotation_direction(0)
			// },
			// KEY_DOWN => {
			// 	on_pressed: () -> bot.set_acceleration(true),
			// 	on_released: () -> bot.set_acceleration(false)
			// },
			MOUSE_LEFT => {
				on_pressed: () -> {
					// var center_cheese = cheese.entity.collision_center(model_translation);
					// var overlaps = bot.entity.collision_center(model_translation).point_overlaps_circle(center_cheese, 5);
					// trace(game.input.mouse_position.x
					// 	+ ', '
					// 	+ game.input.mouse_position.y
					// 	+ ' '
					// 	+ overlaps
					// 	+ center_cheese.x
					// 	+ ', '
					// 	+ center_cheese.y);
				}
			},
			KEY_T => {
				on_pressed: () -> {
					trace('bot');
					for (vector in bot.entity.collision_points()) {
						trace(vector.x + ', ' + vector.y);
					}
					// trace('cheese');
					// for (vector in cheese.entity.collision_points()) {
					// 	trace(vector.x + ', ' + vector.y);
					// }
				}
			},
			KEY_C => {
				on_pressed: () -> {
					trace('cheese spawn');
					cheeseWheel.create(x_center, y_center, file.models[0],  model_translation, game.graphics);
				}
			}
		];

		controller = new Controller(actions, game.input);
		game.input.on_pressed = button -> controller.handle_button(PRESSED, button);
		game.input.on_released = button -> controller.handle_button(RELEASED, button);
		// game.input.on_pressed = button -> {
		// 	switch button {
		// 		case KEY_LEFT: controller.handle_button(PRESSED, KEY_LEFT);
		// 		case KEY_RIGHT: controller.handle_button(PRESSED, KEY_RIGHT);
		// 		case KEY_DOWN: controller.handle_button(PRESSED, KEY_DOWN);
		// 		case _: return;
		// 	}
		// }

		// game.input.on_released = button -> {
		// 	switch button {
		// 		case KEY_LEFT: controller.handle_button(RELEASED, KEY_LEFT);
		// 		case KEY_RIGHT: controller.handle_button(RELEASED, KEY_RIGHT);
		// 		case KEY_DOWN: controller.handle_button(RELEASED, KEY_DOWN);
		// 		case _: return;
		// 	}
		// }
		cheeseWheel = new CheeseWheel();

		var page:Page = {
			pads: [],
			name: "one",
		}
		settings.page_add(page);

		var bind_geo_pad:(fill:Entity, name:String, index_palette:Int) -> Void = (fill:Entity, name:String, index_palette:Int) -> {
			settings.pad_add({
				name: name,
				index_palette: index_palette,
				// index: index,
				encoders: [
					VOLUME => {
						value: fill.lines.origin.y,
						on_change: f -> fill.lines.origin.y = f,
						name: "y origin ",
						increment: 0.1
					},
					PAN => {
						value: fill.offset,
						on_change: f -> fill.offset = f,
						name: "offset",
						increment: 1,
						minimum: -1000
					},
					FILTER => {
						value: fill.scale,
						on_change: f -> fill.scale = Std.int(f),
						name: "scale",
						// increment: 0.1,
						minimum: 0.001
					},
					RESONANCE => {
						value: fill.rotation,
						on_change: f -> fill.rotation = f,
						name: "angle",
						increment: 0.1,
						minimum: -360
					}
				]
			}, page.index);
		}
		var g:Graphics = cast game.graphics;
		@:privateAccess
		var display = g.display;

		settings.pad_add({
			name: "camera",
			index_palette: 4,
			// index: index,
			encoders: [
				VOLUME => {
					value: display.xOffset,
					on_change: f -> display.xOffset = f,
					name: "x offset",
					minimum: -1000,
					increment: 10
				},
				PAN => {
					value: display.yOffset,
					on_change: f -> display.yOffset = f,
					name: "y offset",
					minimum: -1000,
					increment: 10
				},
				// FILTER => {
				// 	value: fill.scale,
				// 	on_change: f -> fill.scale = Std.int(f),
				// 	name: "scale",
				// 	// increment: 0.1,
				// 	minimum: 0.001
				// },
				RESONANCE => {
					value: display.zoom,
					on_change: f -> display.zoom = f,
					name: "zoom",
					minimum: 0.1,
					increment: 0.1
				}
			]
		}, page.index);

		@:privateAccess
		bind_geo_pad(bot.entity, "bot", 0);
		// @:privateAccess
		// bind_geo_pad(cheese.entity, "cheese", 1);
	}

	public function update(elapsed_seconds:Float) {
		cheeseWheel.update(elapsed_seconds);
		bot.update(elapsed_seconds);

		final red:Int = 0xFF0000ff;
		final white:Int = 0xFFFFFFff;
		// var overlaps = bot.entity.collision_center(model_translation).point_overlaps_circle(cheese.entity.collision_center(model_translation), 20);
		// if (overlaps && cheese.is_active) {
		// 	cheese_collect(cheese);
		// }
		var overlaps = cheeseWheel.overlaps(bot.entity.collision_center(model_translation));
		for(cheese in overlaps){
			cheeseWheel.remove(cheese);
			// bot.entity.set_color(overlaps ? red : white);

		}
	}

	public function draw() {
		cheeseWheel.draw();
		bot.draw();
	}

	function cheese_collect(cheese:Shape) {
		// cheese.is_active = false;

		// cheese = null;
	}
}

class CheeseWheel {
	var cheeses:Array<Shape>;
	var model_translation:EditorTranslation;

	public function new() {
		cheeses = [];
	}
	
	public function create(x, y, model:FigureModel, model_translation:EditorTranslation, graphics:GraphicsAbstract):Shape {
		this.model_translation = model_translation;
		var cheese = new Shape(x, y, graphics, model, model_translation);
		@:privateAccess
		cheese.entity.lines.origin.y = 2.6;
		cheese.entity.scale = 76;
		cheese.entity.set_rotation_direction(-1);
		cheeses.push(cheese);
		return cheese;
	}

	public function overlaps(target:Vector):Array<Shape>{
		var matching = cheeses.filter(shape -> target.point_overlaps_circle(shape.entity.collision_center(model_translation), 20));
		return matching;
		// bot.entity.collision_center(model_translation).point_overlaps_circle(cheese.entity.collision_center(model_translation), 20);
	}

	public function remove(cheese:Shape) {
		if (cheeses.contains(cheese)) {
			cheese.entity.lines.erase();
			cheeses.remove(cheese);
		}
	}

	public function update(elapsed_seconds:Float) {
		for (cheese in cheeses) {
			cheese.update(elapsed_seconds);
		}
	}

	public function draw() {
		for (cheese in cheeses) {
			cheese.draw();
		}
	}
}
