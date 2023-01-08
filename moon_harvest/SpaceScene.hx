import Random.randomInt;
import peote.view.PeoteView;
import GraphicsAbstract.AbstractLine;
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
	var actor:Actor;
	var x_center:Int;
	var y_center:Int;

	var controller:Controller;
	var settings:SettingsController;
	var file:FileModel;
	var model_translation:EditorTranslation;
	var cheeseWheel:CheeseWheel;

	var countdown_cheese_release:CountDown;
	var countdown_phase_cheese_release:CountDown;

	public function init() {
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);
		var models_json = Assets.getText('assets/alphabet-01.json');

		file = Disk.parse_file_contents(models_json);
		// @:privateAccess
		// var graphics:Graphics = cast game.graphics;

		// var hud_bounds:RectangleGeometry = {
		// 	y: 0,
		// 	x: 0,
		// 	width: graphics.viewport_bounds.width,
		// 	height: Std.int(graphics.viewport_bounds.height * 0.3)
		// }

		var model_bounds:RectangleGeometry = {
			y: 0,
			x: 0,
			width: 42,
			height: 42
		}
		model_translation = new EditorTranslation(model_bounds, 1, 1);

		settings = new SettingsController(new DiskSys());
		// settings.disk_load();

		var bot = new Shape(x_center, y_center, game.graphics, file.models[0], model_translation);
		// bot.entity.scale = 66;
		// bot.entity.rotation = -3.73;
		// bot.entity.set_rotation_direction(0);
		// // @:privateAccess
		bot.entity.lines.origin.y = 18;
		bot.entity.scale = 0.5;
		actor = new Actor(bot);

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
					actor.press();
				},
				on_released: () -> {
					actor.release();
				}
			},
			KEY_T => {
				// on_pressed: () -> {
				// 	trace('bot');
				// 	for (vector in bot.entity.collision_points()) {
				// 		trace(vector.x + ', ' + vector.y);
				// 	}
				// trace('cheese');
				// for (vector in cheese.entity.collision_points()) {
				// 	trace(vector.x + ', ' + vector.y);
				// }
				// }
			},
			KEY_C => {
				on_pressed: () -> {
					trace('cheese spawn');
					// var index = randomInt(2, 7);
					cheeseWheel.create(x_center, y_center, file.models[0], model_translation, game.graphics);
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

		var bind_geo_pad:(entity:Entity, name:String, index_palette:Int) -> Void = (entity:Entity, name:String, index_palette:Int) -> {
			settings.pad_add({
				name: name,
				index_palette: index_palette,
				// index: index,
				encoders: [
					VOLUME => {
						value: entity.lines.origin.y,
						on_change: f -> {
							entity.lines.origin.y = f;
							actor.y = entity.lines.origin.y;
						},
						name: "y origin ",
						increment: 0.1
					},
					// PAN => {
					// 	value: entity.rotation_speed,
					// 	on_change: f -> entity.rotation_speed = f,
					// 	name: "speed",
					// 	increment: 0.01,
					// 	minimum: -1000
					// },
					FILTER => {
						value: entity.scale,
						on_change: f -> entity.scale = f,
						name: "scale",
						// increment: 0.1,
						minimum: 0.00001
					},
					RESONANCE => {
						value: entity.rotation,
						on_change: f -> entity.rotation = f,
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
		display.zoom = 1.16;
		display.xOffset = 0;
		display.yOffset = 0;
		settings.pad_add({
			name: "camera",
			index_palette: 4,
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

		@:privateAccess
		bind_geo_pad(bot.entity, "bot", 0);
		// @:privateAccess
		// bind_geo_pad(cheese.entity, "cheese", 1);

		settings.pad_add({
			name: "cheese",
			index_palette: 4,
			// index: index,
			encoders: [
				VOLUME => {
					value: cheeseWheel.y_origin,
					on_change: f -> cheeseWheel.y_origin = f,
					name: "y origin",
					minimum: -1000,
					increment: 0.1
				},
				PAN => {
					value: cheeseWheel.scale,
					on_change: f -> cheeseWheel.scale = Std.int(f),
					name: "scale",
					minimum: 0.1,
					increment: 1
				},
				FILTER => {
					value: cheeseWheel.rotation_speed,
					on_change: f -> cheeseWheel.rotation_speed = f,
					name: "speed",
					increment: 0.01,
					minimum: -100000,
				},
				RESONANCE => {
					value: cheeseWheel.overlap,
					on_change: f -> cheeseWheel.overlap = f,
					name: "overlap",
					minimum: 0.1,
					increment: 0.1
				}
			]
		}, page.index);

		countdown_cheese_release = new CountDown(0.9, () -> {
			// var i = randomInt(2,20);
			cheeseWheel.create(x_center, y_center, file.models[0], model_translation, game.graphics);
		}, true);
		countdown_phase_cheese_release = new CountDown(2.1, () -> {
			// // if(countdown_cheese_release.restartWhenComplete ){
			// 	// 	countdown_cheese_release.stop();
			// 	// }
			// @:privateAccess
			// countdown_cheese_release.restartWhenComplete = !countdown_cheese_release.restartWhenComplete;
			// countdown_cheese_release.reset();
		});

		// var bounds_hud:RectangleGeometry = {
		// 	y: 0,
		// 	x: 0,
		// 	width: graphics.viewport_bounds.width,
		// 	height: Std.int(graphics.viewport_bounds.height * 0.4)
		// }
		// @:privateAccess
		// // var hud_graphics = new Graphics(graphics.peoteview, hud_bounds);
		// var hud = new Hud(graphics.peoteview, bounds_hud, file.models, model_translation);
	}

	public function update(elapsed_seconds:Float) {
		countdown_cheese_release.update(elapsed_seconds);
		countdown_phase_cheese_release.update(elapsed_seconds);
		cheeseWheel.update(elapsed_seconds);
		actor.update(elapsed_seconds);

		// var overlaps = cheeseWheel.overlaps(actor.graphic.entity.collision_center(model_translation));
		var overlaps = cheeseWheel.overlaps_a_line(actor.graphic.entity.lines.lines);
		for (cheese in overlaps) {
			cheeseWheel.remove(cheese);
			// final red:Int = 0xFF0000ff;
			// final white:Int = 0xFFFFFFff;
			// bot.entity.set_color(overlaps ? red : white);
		}
	}

	public function draw() {
		cheeseWheel.draw();
		actor.draw();
	}
}
