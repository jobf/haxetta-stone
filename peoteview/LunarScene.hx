import Models;
import GraphicsAbstract.RGBA;
import graphics.Sprite;
import lime.app.Application;
import graphics.implementation.Graphics;
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
	var countdown_cheese_toggle:CountDown;
	var countdown_obstacle_toggle:CountDown;
	var countdown_invincible:CountDown;

	var performer:Performer;
	var controller:Controller;
	var display_main:Display;
	// var display_hud:Display;
	var graphics_main:Graphics;
	var graphics_hud:Graphics;
	// var peoteview:PeoteView;
	var hud:Hud;
	var settings:SettingsController;

	var is_invincible:Bool = false;
	var moon:Sprite;

	public function new(graphics_hud:Graphics, bounds:RectangleGeometry, game:Game, color:RGBA){
		super(game, bounds, color);
		this.graphics_hud = graphics_hud;
	}
	public function init() {
		this.graphics_main = cast game.graphics;
		@:privateAccess
		display_main = graphics_main.display;

		// @:privateAccess
		// peoteview = g.peoteview;

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

		moon = graphics_main.add_moon(Assets.getImage('images/placeholder_moon.png'));
		moon.c = 0xebd0cfFF;

		var models_json = Assets.getText('models/alphabet-01.json');

		file = Disk.parse_file_contents(models_json);

		hud = new Hud(graphics_hud, {
			y: 0,
			x: 0,
			width: bounds.width,
			height: bounds.height,
		}, file.models, model_translation);
		// hud.write_message("HELLO 0001");

		draw_bot();
		performer = new Performer(drawing);

		wheel_cheese = new Wheel(0xc2b97aFF, 100);
		countdown_cheese_release = new CountDown(0.2, () -> {
			var i = Random.randomInt(38,42);
			// trace('model $i out of ${file.models.length}');
			wheel_cheese.create(x, y, file.models[i], model_translation, game.graphics);

		}, true);
		countdown_cheese_toggle = new CountDown(1.0, () ->{
			countdown_cheese_release.enabled = !countdown_cheese_release.enabled;
		}, true);
/**
obstacles

45-48

hi-score

49-50

life
51

**/
		wheel_obstacle = new Wheel(moon.c, 30);
		countdown_obstacle_release = new CountDown(0.3, ()->{
			var i = Random.randomInt(45,48);
			wheel_obstacle.create(x, y, file.models[i], model_translation, game.graphics);
		}, true);
		countdown_obstacle_toggle = new CountDown(1.0, () ->{
			countdown_obstacle_release.enabled = !countdown_obstacle_release.enabled;
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
					// wheel_cheese.create(x, y, file.models[0], model_translation, game.graphics);
					wheel_cheese.remove_all();
					wheel_obstacle.remove_all();
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


		
		performer.rotation_speed = 0.0003;
		
		
		countdown_invincible = new CountDown(2, () -> {
			is_invincible = false;
			performer.set_flashing(false);
		});
		hud.lives_change(lives);


		settings_bind();
	}

	function quit(){
		@:privateAccess
		settings.fire.shutDown();
		Application.current.window.close();
	}

	function draw_bot(){
		drawing = new Drawing({
			model_lines: file.models[model_index].lines
		},
		x,
		y,
		game.graphics.make_line,
		model_translation);
	}

	public function update(elapsed_seconds:Float) {
		countdown_obstacle_toggle.update(elapsed_seconds);
		countdown_cheese_toggle.update(elapsed_seconds);
		countdown_invincible.update(elapsed_seconds);
		countdown_cheese_release.update(elapsed_seconds);
		performer.update(elapsed_seconds);
		hud.set_thrust_bar(performer.amp_jump_env.now() * performer.amp_fall_env.now());
		wheel_cheese.update(elapsed_seconds);
		countdown_obstacle_release.update(elapsed_seconds);
		wheel_obstacle.update(elapsed_seconds);
		moon.rotation -= (wheel_obstacle.rotation_speed) * 55;

		var overlaps = wheel_cheese.overlaps_a_line(drawing.lines);
		for (cheese in overlaps) {
			wheel_cheese.remove(cheese);
			hud.score_change(10);
			// final red:Int = 0xFF0000ff;
			// final white:Int = 0xFFFFFFff;
			// bot.entity.set_color(overlaps ? red : white);
		}

		var overlaps = wheel_obstacle.overlaps_a_line(drawing.lines);
		for(obstacle in overlaps){
			if(!is_invincible){
				reduce_lives();
			}
			break;
		}
	}

	var lives = 3;
	function reduce_lives() {
		if(lives > 0){
			lives--;
			is_invincible = true;
			performer.set_flashing(true);
			countdown_invincible.reset();
			hud.lives_change(lives);
			trace('hit $lives left');
		}
		else{
			trace('no lives, end');
			performer.rotation = -1.62;
			wheel_cheese.remove_all();
			wheel_obstacle.remove_all();
			hud.score_reset();
			lives = 3;
			hud.lives_change(lives);
		}
		
	}
	
	public function draw() {
		drawing.draw();
		hud.draw();
	}


	function settings_bind(){

		display_main.zoom = 1.0;
		display_main.xOffset = 0;
		display_main.yOffset = 0;



		var page:Page = {
			name: "yoo",
			pads: [
				{
					name: "camera",
					index_palette: 0,
					index: 0,
					encoders: [
						VOLUME => {
							value: display_main.xOffset,
							on_change: f -> display_main.xOffset = f,
							name: "x offset",
							minimum: -1000,
							maximum: 1000,
							increment: 5
						},
						PAN => {
							value: display_main.yOffset,
							on_change: f -> display_main.yOffset = f,
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
							value: display_main.zoom,
							on_change: f -> display_main.zoom = f,
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
				},
				{
					name: "timing",
					index_palette: 4,
					index: 4,
					encoders: [
						VOLUME => {
							value: countdown_cheese_release.duration,
							on_change: f -> {
								countdown_cheese_release.duration = f;
								countdown_cheese_release.countDown = f;
							},
							name: "cheese",
							increment: 0.01,
							minimum: -10,
							maximum: 100
						},
						PAN => {
							value: countdown_obstacle_release.duration,
							on_change: f -> {
								countdown_obstacle_release.duration = f;
								countdown_obstacle_release.countDown = f;
							},
							name: "obstacle",
							increment: 0.01,
							minimum: -10,
							maximum: 10
						},
						// FILTER => {
						// 	value: performer.amp_fall_env.releaseTime,
						// 	on_change: f -> performer.amp_fall_env.releaseTime = f,
						// 	name: "bot fall",
						// 	increment: 0.1,
						// 	minimum: 0.00001
						// },
						// RESONANCE => {
						// 	value: 0,
						// 	on_change: f -> return,
						// 	name: "0",
						// 	// increment: 0.1,
						// 	// minimum: -360
						// }
					]
				},
				{
					name: "bot jump",
					index_palette: 5,
					index: 5,
					encoders: [
						VOLUME => {
							value: performer.amp_jump_env.attackTime,
							on_change: f -> performer.amp_jump_env.attackTime = f,
							name: "rise",
							increment: 0.01,
							minimum: 0.0001,
							maximum: 100
						},
						PAN => {
							value: performer.amp_fall_env.releaseTime,
							on_change: f -> performer.amp_fall_env.releaseTime = f,
							name: "fall",
							increment: 0.01,
							minimum: 0.0001,
							maximum: 100
						},
						FILTER => {
							value: performer.amp_jump_env.releaseTime,
							on_change: f -> performer.amp_jump_env.releaseTime = f,
							name: "drop",
							increment: 0.01,
							minimum: 0.0001,
							maximum: 100
						},
						RESONANCE => {
							value: performer.jump_height,
							on_change: f -> performer.jump_height = f,
							name: "height",
							increment: 0.1,
							minimum: -1,
							maximum: 1
						}
					]
				},
			]
		}

		#if web
		settings = new SettingsController(new DiskAssets());
		#else
		settings = new SettingsController(new DiskSys());
		#end
		settings.page_add(page);
		



		// settings.pad_add(, page.index);
		// settings.pad_add(, page.index);
		// settings.pad_add(, page.index);

		settings.disk_load();
	}


	public function close() {}
}
