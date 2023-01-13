import GraphicsAbstract;
import graphics.implementation.Graphics;
import GraphicsAbstract.RGBA;
import graphics.ui.Slider;
import Engine;
import Text;

class TextScene extends Scene {
	var text:Text;
	var test:Word;
	var slider:Slider;
	var ui:Ui;
	var fill:AbstractFillRectangle;
	var toggle:Toggle;



	public function init() {
		var font = font_load_embedded();
		font.width_model = 26;
		font.height_model = 26;
		font.width_character = 14;

		var color:RGBA = 0xffffffFF;
		text = new Text(font, game.graphics);
		test = text.word_make(30, 200, "TEST", color);

		var width_fill = 40;
		fill = game.graphics.make_fill(300, 300, width_fill, width_fill, 0xff00ffFF);

		ui = new Ui({
			word_make: text.word_make,
			line_make: game.graphics.make_line,
			fill_make: game.graphics.make_fill
		});

		slider = ui.make_slider({
			y: 400,
			x: 200,
			width: 200,
			height: 50 + font.height_model
		}, "WIDTH", color);

		var is_enabled = true;
		toggle = ui.make_toggle({
			y: 480,
			x: 200,
			width: Std.int(font.width_model * 1.3),
			height: 50 + font.height_model
		}, "VISIBLE", color, is_enabled);
		toggle.on_change = b -> {
			fill.color.a = b ? 255 : 0;
		}

		var width_max = 100;
		var width_min = width_fill;
		slider.on_move = f -> {
			fill.width = (width_max * f) + width_min;
		};

		// todo - make on_pressed an event dispatcher
		game.input.on_pressed = button -> switch button {
			case MOUSE_LEFT: click();
			case _:
		}


		// todo - make on_released an event dispatcher
		game.input.on_released = button -> switch button {
			case MOUSE_LEFT: release();
			case _:
		}

		mouse_position_previous = {
			x: game.input.mouse_position.x,
			y: game.input.mouse_position.y
		}
	}

	function release() {
		var x_mouse = Std.int(game.input.mouse_position.x);
		var y_mouse = Std.int(game.input.mouse_position.y);
		ui.handle_mouse_release(x_mouse, y_mouse);
	}

	function click() {
		var x_mouse = Std.int(game.input.mouse_position.x);
		var y_mouse = Std.int(game.input.mouse_position.y);
		ui.handle_mouse_click(x_mouse, y_mouse);
	}

	var mouse_position_previous:Vector;
	public function update(elapsed_seconds:Float) {
		var is_x_mouse_changed = game.input.mouse_position.x != mouse_position_previous.x;
		var is_y_mouse_changed = game.input.mouse_position.y != mouse_position_previous.y;

		if(is_x_mouse_changed || is_y_mouse_changed){
			mouse_position_previous.x = game.input.mouse_position.x;
			mouse_position_previous.y = game.input.mouse_position.y;
			var x_mouse = Std.int(game.input.mouse_position.x);
			var y_mouse = Std.int(game.input.mouse_position.y);
			ui.handle_mouse_moved(x_mouse, y_mouse);
		}
	}

	public function draw() {
		text.draw();
	}

	public function close() {}
}
