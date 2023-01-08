import lime.app.Application;
import Graphics;
import peote.view.PeoteView;
import peote.view.Display;
import dials.Disk;
import dials.SettingsController;
import lime.utils.AssetType;
import lime.utils.Assets;
import Editor;
import Controller;
import InputAbstract;
import Engine;
import Disk;
import Drawing;
import Performer;
import Wheel;

using Vector;



class LunarScene extends Scene {
	var model_translation:EditorTranslation;
	var model_index:Int = 0;
	var file:FileModel;
	var x:Float = 0;
	var y:Float = 0;

	var drawing:Drawing;
	var wheel_cheese:Wheel;
	var wheel_obstacle:Wheel;

	var countdown_cheese_release:CountDown;
	var countdown_obstacle_release:CountDown;
	var performer:Performer;
	var controller:Controller;
	var display:Display;
	var peoteview:PeoteView;
	var hud:Hud;
	var settings:SettingsController;

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

		wheel_cheese = new Wheel(0xc2b97aFF);
		countdown_cheese_release = new CountDown(1.2, () -> {
			var i = Random.randomInt(38,42);
			// trace('model $i out of ${file.models.length}');
			wheel_cheese.create(x, y, file.models[i], model_translation, game.graphics);
		}, true);

		wheel_obstacle = new Wheel(0xd68181FF);
		countdown_obstacle_release = new CountDown(2.3, ()->{
			wheel_obstacle.create(x, y, file.models[0], model_translation, game.graphics);
		}, true);

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
					wheel_cheese.create(x, y, file.models[0], model_translation, game.graphics);
				}
			},
			KEY_Q => {
				on_pressed: ()-> {
					quit();
				}
			}
		];


		controller = new Controller(actions, game.input);
		game.input.on_pressed = button -> controller.handle_button(PRESSED, button);
		game.input.on_released = button -> controller.handle_button(RELEASED, button);


		settings_bind();
	}

	function quit(){
		@:privateAccess
		settings.fire.shutDown();
		Application.current.window.close();
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
		wheel_cheese.update(elapsed_seconds);
		countdown_obstacle_release.update(elapsed_seconds);
		wheel_obstacle.update(elapsed_seconds);
		// drawing.draw
		var overlaps = wheel_cheese.overlaps_a_line(drawing.lines);
		for (cheese in overlaps) {
			wheel_cheese.remove(cheese);
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

		display.zoom = 1.0;
		display.xOffset = 0;
		display.yOffset = 0;



		var page:Page = {
			name: "yoo",
			pads: [
				{
					name: "camera",
					index_palette: 0,
					index: 0,
					encoders: [
						VOLUME => {
							value: display.xOffset,
							on_change: f -> display.xOffset = f,
							name: "x offset",
							minimum: -1000,
							maximum: 1000,
							increment: 5
						},
						PAN => {
							value: display.yOffset,
							on_change: f -> display.yOffset = f,
							name: "y offset",
							minimum: -1000,
							maximum: 1000,
							increment: 5
						},
						// FILTER => {
						// 	value: 0,
						// 	on_change: f -> return,
						// 	name: "0",
						// 	// increment: 0.1,
						// 	// minimum: 0.001
						// },
						RESONANCE => {
							value: display.zoom,
							on_change: f -> display.zoom = f,
							name: "zoom",
							minimum: 0.1,
							maximum: 10,
							increment: 0.01
						}
					]
				},
				{
					name: "bot",
					index_palette: 1,
					index: 1,
					encoders: [
						VOLUME => {
							value: performer.y,
							on_change: f -> performer.y = f,
							name: "y",
							increment: 0.01,
							minimum: -10000,
							maximum: 10000
						},
						PAN => {
							value: performer.rotation,
							on_change: f -> performer.rotation = f,
							name: "angle",
							increment: 0.01,
							minimum: -360,
							maximum: 360
						},
						FILTER => {
							value: performer.scale,
							on_change: f -> performer.scale = f,
							name: "scale",
							increment: 0.01,
							minimum: 0.00001
						},
						RESONANCE => {
							value: performer.jump_height,
							on_change: f -> performer.jump_height = f,
							name: "jump",
							increment: 0.1,
							minimum: -10000,
							maximum: 10000
						}
					]
				},
				{
					name: "wheel_cheese",
					index_palette: 2,
					index: 2,
					encoders: [
						VOLUME => {
							value: wheel_cheese.y_origin,
							on_change: f -> wheel_cheese.y_origin = f,
							name: "y origin ",
							increment: 0.01,
							minimum: -10000,
							maximum: 10000
						},
						PAN => {
							value: wheel_cheese.rotation_speed,
							on_change: f -> wheel_cheese.rotation_speed = f,
							name: "speed",
							increment: 0.01,
							minimum: -10,
							maximum: 10
						},
						FILTER => {
							value: wheel_cheese.scale,
							on_change: f -> wheel_cheese.scale = f,
							name: "scale",
							increment: 0.1,
							minimum: 0.00001
						},
						RESONANCE => {
							value: 0,
							on_change: f -> return,
							name: "0",
							// increment: 0.1,
							// minimum: -360
						}
					]
				},
				{
					name: "wheel_obstacle",
					index_palette: 3,
					index: 3,
					encoders: [
						VOLUME => {
							value: wheel_obstacle.y_origin,
							on_change: f -> wheel_obstacle.y_origin = f,
							name: "y origin ",
							increment: 0.01,
							minimum: -10000,
							maximum: 10000
						},
						PAN => {
							value: wheel_obstacle.rotation_speed,
							on_change: f -> wheel_obstacle.rotation_speed = f,
							name: "speed",
							increment: 0.01,
							minimum: -10,
							maximum: 10
						},
						FILTER => {
							value: wheel_obstacle.scale,
							on_change: f -> wheel_obstacle.scale = f,
							name: "scale",
							increment: 0.1,
							minimum: 0.00001
						},
						RESONANCE => {
							value: 0,
							on_change: f -> return,
							name: "0",
							// increment: 0.1,
							// minimum: -360
						}
					]
				}
			]
		}

		settings = new SettingsController(new DiskSys());
		settings.page_add(page);
		



		// settings.pad_add(, page.index);
		// settings.pad_add(, page.index);
		// settings.pad_add(, page.index);

		settings.disk_load();
	}

}
