import Editor.Designer;
import Models;
import GraphicsAbstract;
import Controller;
import InputAbstract;
import Engine;
import Disk;

using Vector;

class DesignerScene extends Scene {
	var x_center:Int;
	var y_center:Int;
	var mouse_position:Vector;
	var designer:Designer;

	public function init() {
		game.input.mouse_cursor_hide();
		
		mouse_position = game.input.mouse_position;
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);
		
		var size_segment = Std.int(game.graphics.viewport_bounds.width / 7);
		for (x in 0...Std.int(bounds.width / size_segment)) {
			var x_ = Std.int(x * size_segment);
			game.graphics.make_line(x_, 0, x_, bounds.height, 0xD1D76240);
		}
		for (y in 0...Std.int(bounds.height / size_segment)) {
			var y_ = Std.int(y * size_segment);
			game.graphics.make_line(0, y_, bounds.width, y_, 0xD1D76240);
		}

		var x_axis_line = game.graphics.make_line(0, y_center, bounds.width, y_center, 0xFF85AB50);
		var y_axis_line = game.graphics.make_line(x_center, 0, x_center, bounds.height, 0xFF85AB50);

		designer = new Designer(size_segment, game.graphics);

		var actions:Map<Button, Action> = [
			MOUSE_LEFT => {
				on_pressed: () -> handle_mouse_press_left(),
				on_released: () -> handle_mouse_release_left()
			},
			MOUSE_RIGHT => {
				on_pressed: () -> handle_mouse_press_right(),
			},
			MOUSE_MIDDLE => {
				on_pressed: () -> designer.save_state(),
			},
			KEY_LEFT => {
				on_pressed: () -> designer.set_active_figure(-1)
			},
			KEY_RIGHT => {
				on_pressed: () -> designer.set_active_figure(1)
			},
			KEY_N => {
				on_pressed: () -> designer.add_new_figure()
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
	}

	public function update(elapsed_seconds:Float) {
		mouse_position.x = game.input.mouse_position.x;
		mouse_position.y = game.input.mouse_position.y;
		designer.update_mouse_pointer(mouse_position);
	}

	public function draw() {
		// ?
	}

	function handle_mouse_press_left() {
		if (!designer.isDrawingLine) {
			designer.start_drawing_line({
				x: mouse_position.x,
				y: mouse_position.y
			});
		}
	}

	function handle_mouse_release_left() {
		if (designer.isDrawingLine) {
			designer.stop_drawing_line({
				x: mouse_position.x,
				y: mouse_position.y
			});
		}
	}

	function handle_mouse_press_right() {
		designer.line_under_cursor_remove();
	}
}
