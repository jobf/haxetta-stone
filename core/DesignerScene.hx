import GraphicsAbstract;
import Controller;
import InputAbstract;
import Engine;

class DesignerScene extends Scene{
	
	var x_center:Int;
	var y_center:Int;
	var mouse_position:Vector;
	var isDrawingLine:Bool = false;
	var lines:Array<AbstractLine> = [];

	public function init() {
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);

		var actions:Map<Button, Action> = [
			MOUSE_LEFT => {
				on_pressed: () -> mouse_handle_press(),
				on_released: () -> mouse_handle_release()
			}
		];

		game.input.on_pressed = button -> {
			if(actions.exists(button)){
				actions[button].on_pressed();
			}
		}

		game.input.on_released = button -> {
			if(actions.exists(button)){
				actions[button].on_released();
			}
		}
	}

	public function update(elapsed_seconds:Float) {
		mouse_position = game.input.get_mouse_position();
	}

	public function draw() {
		if(isDrawingLine){
			lines[lines.length - 1].draw(mouse_position, 0xFFFFFFff);
		}
	}

	function mouse_handle_press() {
		trace('mouse press ${mouse_position.x} ${mouse_position.y}');
		if(!isDrawingLine){
			isDrawingLine = true;
			start_drawing_line(mouse_position);
		}
	}

	function mouse_handle_release() {
		if(isDrawingLine){
			trace('mouse release ${mouse_position.x} ${mouse_position.y}');
			isDrawingLine = false;
			stop_drawing_line(mouse_position);
		}
	}

	function start_drawing_line(point:Vector) {
		trace('start_drawing_line ${point.x} ${point.y}');
		lines.push(game.graphics.make_line(point.x, point.y, 0xFFFFFFff));
	}
	

	function stop_drawing_line(point:Vector) {
		trace('stop_drawing_line ${point.x} ${point.y}');
		lines[lines.length - 1].draw(point, 0xFFFFFFff);
	}
}
