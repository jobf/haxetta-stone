import GraphicsAbstract;
import Controller;
import InputAbstract;
import Engine;

class DesignerScene extends Scene {
	var x_center:Int;
	var y_center:Int;
	var mouse_position:Vector;
	var isDrawingLine:Bool = false;
	var lines:Array<AbstractLine>;

	public function init() {
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);
		var x_axis_line = game.graphics.make_line(0, y_center, bounds.width, y_center, 0xFFFF00ff);
		var y_axis_line = game.graphics.make_line(x_center, 0, x_center, bounds.height, 0xFFFF00ff);

		lines = [];

		var actions:Map<Button, Action> = [
			MOUSE_LEFT => {
				on_pressed: () -> mouse_handle_press(),
				on_released: () -> mouse_handle_release()
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
		mouse_position = game.input.mouse_position;
		if (isDrawingLine) {
			var line = lines[lines.length - 1];
			line.point_to.x = mouse_position.x;
			line.point_to.y = mouse_position.y;
		}
	}

	public function draw() {
		// ?
	}

	function mouse_handle_press() {
		trace('mouse press ${mouse_position.x} ${mouse_position.y}');
		if (!isDrawingLine) {
			isDrawingLine = true;
			start_drawing_line(mouse_position);
		}
	}

	function mouse_handle_release() {
		if (isDrawingLine) {
			trace('mouse release ${mouse_position.x} ${mouse_position.y}');
			isDrawingLine = false;
			stop_drawing_line(mouse_position);
		}
	}

	function start_drawing_line(point:Vector) {
		trace('start_drawing_line ${point.x} ${point.y}');
		lines.push(game.graphics.make_line(point.x, point.y, point.x + 1, point.y + 1, 0xFFFFFFff));
	}

	function stop_drawing_line(point:Vector) {
		trace('stop_drawing_line ${point.x} ${point.y}');
		var line = lines[lines.length - 1];
		line.point_to.x = mouse_position.x;
		line.point_to.y = mouse_position.y;
	}
}
