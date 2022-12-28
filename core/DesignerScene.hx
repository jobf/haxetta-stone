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
	var isDrawingLine:Bool = false;
	var figure:Figure;
	var line_under_cursor:AbstractLine;
	var mouse_pointer:AbstractFillRectangle;
	var size_segment:Int;
	var state_file_path:String = 'test-models.json';

	public function init() {
		game.input.mouse_cursor_hide();
		size_segment = Std.int(game.graphics.viewport_bounds.width / 6);
		var editor = new Editor({
			y: 0,
			x: 0,
			width: game.graphics.viewport_bounds.width,
			height: game.graphics.viewport_bounds.height
		});
		mouse_position = game.input.mouse_position;
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);
		for (x in 0...Std.int(bounds.width / size_segment)) {
			var x_ = Std.int(x * size_segment);
			game.graphics.make_line(x_, 0, x_, bounds.height, 0x7020706f);
			for (y in 0...Std.int(bounds.height / size_segment)) {
				var y_ = Std.int(y * size_segment);
				game.graphics.make_line(0, y_, bounds.width, y_, 0x7020706f);
			}
		}
		var x_axis_line = game.graphics.make_line(0, y_center, bounds.width, y_center, 0xFFFF008f);
		var y_axis_line = game.graphics.make_line(x_center, 0, x_center, bounds.height, 0xFFFF008f);
		mouse_pointer = game.graphics.make_fill(0, 0, 10, 10, 0xFF448080);
		
		var actions:Map<Button, Action> = [
			MOUSE_LEFT => {
				on_pressed: () -> handle_mouse_press_left(),
				on_released: () -> handle_mouse_release_left()
			},
			MOUSE_RIGHT => {
				on_pressed: () -> handle_mouse_press_right(),
			},
			MOUSE_MIDDLE => {
				on_pressed: () -> save_state(),
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


		figure_init();

	}

	public function update(elapsed_seconds:Float) {
		mouse_position.x = round_to_nearest(game.input.mouse_position.x, size_segment);
		mouse_position.y = round_to_nearest(game.input.mouse_position.y, size_segment);
		// trace('mouse_position ${mouse_position.x} ${mouse_position.y}');
		mouse_pointer.x = mouse_position.x;
		mouse_pointer.y = mouse_position.y;
		line_under_cursor = null;
		if (isDrawingLine) {
			var line = figure.line_newest();
			line.point_to.x = mouse_position.x;
			line.point_to.y = mouse_position.y;
		} else {
			for (line in figure.lines) {
				var overlaps = mouse_position.line_overlaps_point(line.point_from, line.point_to);
				line.color = overlaps ? 0xFF0000ff : 0xFFFFFFff;
				if (overlaps) {
					line_under_cursor = line;
					break;
				}
			}
		}
	}

	public function draw() {
		// ?
	}

	function figure_init(){
		var file:FileModel = Disk.file_read(state_file_path);
		if(file.models.length > 0){
			var model = file.models[0];
			figure = {
				model_points: model.points,
				lines: game.graphics.model_to_lines(model.points, 0xFFFFFFff)
			}
		}
		else{
			figure = {
				lines: [],
				model_points: []
			}
		}

	}

	function handle_mouse_press_left() {
		trace('mouse press ${mouse_pointer.x} ${mouse_pointer.y}');
		if (!isDrawingLine) {
			isDrawingLine = true;
			start_drawing_line({
				x: mouse_pointer.x,
				y: mouse_pointer.y
			});
		}
	}

	function handle_mouse_release_left() {
		if (isDrawingLine) {
			// trace('mouse left release ${mouse_pointer.x} ${mouse_pointer.y}');
			isDrawingLine = false;
			stop_drawing_line({
				x: mouse_pointer.x,
				y: mouse_pointer.y
			});
		}
	}

	function handle_mouse_press_right() {
		// trace('mouse right press ${mouse_pointer.x} ${mouse_pointer.y}');
		if (line_under_cursor != null) {
			line_under_cursor.erase();
			figure.lines.remove(line_under_cursor);
			line_under_cursor = null;
		}
	}

	function save_state() {
		trace("save");
		var model:Model = {
			points: figure.lines.map(line -> line.point_from)
		}
		var models:Array<Model> = [model];
		Disk.file_write_models(models, state_file_path);
	}

	function start_drawing_line(point:Vector) {
		trace('start_drawing_line ${point.x} ${point.y}');
		figure.lines.push(game.graphics.make_line(point.x, point.y, point.x, point.y, 0xFFFFFFff));
	}

	function stop_drawing_line(point:Vector) {
		trace('stop_drawing_line ${point.x} ${point.y}');
		var line = figure.line_newest();
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


@:structInit
class Figure{
	public var model_points:Array<Vector>;
	public var lines:Array<AbstractLine>;

	public function line_newest():AbstractLine{
		return lines[lines.length - 1];
	}
}