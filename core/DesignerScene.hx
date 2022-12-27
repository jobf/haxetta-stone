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
	var mouse_pointer:AbstractFillRectangle;
	final size_segment:Int = 20;

	public function init() {
		game.input.mouse_cursor_hide();
		mouse_position = game.input.mouse_position;
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);
		for(x in 0...Std.int(bounds.width / size_segment)){
			var x_ = Std.int(x *  size_segment);
			game.graphics.make_line(x_, 0, x_, bounds.height, 0x702070af);
			for(y in 0...Std.int(bounds.height / size_segment)){
				var y_ = Std.int(y *  size_segment);
				game.graphics.make_line(0, y_, bounds.width, y_, 0x702070af);
			}
		}
		var x_axis_line = game.graphics.make_line(0, y_center, bounds.width, y_center, 0xFFFF00ff);
		var y_axis_line = game.graphics.make_line(x_center, 0, x_center, bounds.height, 0xFFFF00ff);
		mouse_pointer = game.graphics.make_fill(0, 0, 10, 10, 0xFF448080);

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
		
		mouse_position.x = round_to_nearest(game.input.mouse_position.x, size_segment);
		mouse_position.y = round_to_nearest(game.input.mouse_position.y, size_segment);
		// trace('mouse_position ${mouse_position.x} ${mouse_position.y}');
		mouse_pointer.x = mouse_position.x;
		mouse_pointer.y = mouse_position.y;
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
		trace('mouse press ${mouse_pointer.x} ${mouse_pointer.y}');
		if (!isDrawingLine) {
			isDrawingLine = true;
			start_drawing_line({
				x: mouse_pointer.x,
				y: mouse_pointer.y
			});
		}
	}

	function mouse_handle_release() {
		if (isDrawingLine) {
			trace('mouse release ${mouse_pointer.x} ${mouse_pointer.y}');
			isDrawingLine = false;
			stop_drawing_line({
				x: mouse_pointer.x,
				y: mouse_pointer.y
			});
		}
	}

	function start_drawing_line(point:Vector) {
		trace('start_drawing_line ${point.x} ${point.y}');
		lines.push(game.graphics.make_line(point.x, point.y, point.x, point.y, 0xFFFFFFff));
	}

	function stop_drawing_line(point:Vector) {
		trace('stop_drawing_line ${point.x} ${point.y}');
		var line = lines[lines.length - 1];
		line.point_to.x = round_to_nearest(point.x, size_segment);
		line.point_to.y = round_to_nearest(point.y, size_segment);
		// for (line in lines) {
		// 	trace('${line.point_from.x},${line.point_from.y} -> ${line.point_to.x},${line.point_to.y}');
		// }
	}

	function round_to_nearest(value:Float, interval:Float):Float {
		return Math.round(value / interval) * interval;
	}
}
