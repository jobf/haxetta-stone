import haxe.display.Display.Package;
import GraphicsAbstract;
import Models;
import Disk;
import Engine;

using Vector;

class EditorTranslation {
	var bounds_view:RectangleGeometry;
	var x_center:Int;
	var y_center:Int;
	var points_in_translation_x = 10;
	var points_in_translation_y = 10;
	var bounds_width_half:Float;
	var bounds_height_half:Float;

	public function new(bounds_view:RectangleGeometry, points_in_translation_x:Int = 3, points_in_translation_y:Int = 3) {
		this.bounds_view = bounds_view;
		this.points_in_translation_x = points_in_translation_x;
		this.points_in_translation_y = points_in_translation_y;
		x_center = Std.int(bounds_view.width * 0.5);
		y_center = Std.int(bounds_view.height * 0.5);
		bounds_width_half = bounds_view.width * 0.5;
		bounds_height_half = bounds_view.height * 0.5;
	}

	public function view_to_model_point(point_in_view:Vector):Vector {
		var offset_point:Vector = {
			x: point_in_view.x - bounds_width_half,
			y: point_in_view.y - bounds_height_half
		}

		var transformed_point:Vector = {
			x: (offset_point.x / bounds_view.width) * points_in_translation_x,
			y: (offset_point.y / bounds_view.height) * points_in_translation_y,
		}

		return transformed_point;
	}

	public function model_to_view_point(point_in_model:Vector):Vector {
		var transformed_point:Vector = {
			x: (point_in_model.x * bounds_view.width) / points_in_translation_x,
			y: (point_in_model.y * bounds_view.height) / points_in_translation_y,
		}

		var offset_point:Vector = {
			x: transformed_point.x + bounds_width_half,
			y: transformed_point.y + bounds_height_half
		}

		return offset_point;
	}

}

class Designer {
	var model_index:Int = 0;
	var mouse_pointer:AbstractFillRectangle;

	public var line_under_cursor:AbstractLine;

	var size_segment:Int;
	var size_segment_half:Int;
	var state_file_path:String = 'test-models.json';
	var graphics:GraphicsAbstract;
	var file:FileModel;
	var translation:EditorTranslation;

	public var isDrawingLine(default, null):Bool = false;
	public var figure(default, null):Figure;

	public function new(size_segment:Int, graphics:GraphicsAbstract, bounds:RectangleGeometry) {
		this.size_segment = Std.int(size_segment * 0.5);
		this.size_segment_half = -Std.int(size_segment * 0.5);
		this.graphics = graphics;
		mouse_pointer = graphics.make_fill(0, 0, 10, 10, 0xFF448080);
		translation = new EditorTranslation(bounds, 1, 1);
		figure_init();
	}

	function map_figure(model:Model):Figure {
		
		var convert_line:LineModel->LineModel = line -> {
			from: translation.model_to_view_point(line.from),
			to: translation.model_to_view_point(line.to)
		}

		trace('drawing model with ${model.lines.length} lines');

		return {
			model: model.lines,
			lines: graphics.model_to_lines(model.lines.map(line -> convert_line(line)), 0xFFFFFFff)
		}
	}

	function line_under_cursor_(position_cursor:Vector):Null<AbstractLine> {
		for (line in figure.lines) {
			var overlaps:Bool = position_cursor.line_overlaps_point(line.point_from, line.point_to);
			if (overlaps) {
				return line;
			}
		}
		return null;
	}

	public function line_under_cursor_remove() {
		if (line_under_cursor == null) {
			return;
		}
		var model_point_from = translation.view_to_model_point(line_under_cursor.point_from);
		var model_point_to = translation.view_to_model_point(line_under_cursor.point_to);

		var models_under_cursor = figure.model.filter(
			model -> model.from.x == model_point_from.x
			&& model.from.y == model_point_from.y
			&& model.to.x == model_point_to.x
			&& model.to.y == model_point_to.y);

		if (models_under_cursor.length > 0) {
			figure.model.remove(models_under_cursor[0]);
			figure.lines.remove(line_under_cursor);
			line_under_cursor.erase();
		}
	}

	public function update_mouse_pointer(mouse_position:Vector) {
		mouse_position.x = round_to_nearest(mouse_position.x, size_segment) - size_segment_half;
		mouse_position.y = round_to_nearest(mouse_position.y, size_segment) - size_segment_half;
		mouse_pointer.x = mouse_position.x;
		mouse_pointer.y = mouse_position.y;
		if (isDrawingLine) {
			var line = figure.line_newest();
			line.point_to.x = mouse_position.x;
			line.point_to.y = mouse_position.y;
		} else {
			line_under_cursor = line_under_cursor_(mouse_position);
			for (line in figure.lines) {
				var overlaps = line == line_under_cursor;
				line.color = overlaps ? 0xFF0000ff : 0xFFFFFFff;
			}
		}
	}

	function figure_init() {
		file = Disk.file_read(state_file_path);

		if (file.models.length == 0) {
			file.models = [
				{
					lines: []
				}
			];
		}

		figure = map_figure(file.models[model_index]);
	}

	function clear_figure() {
		trace('clearing figure with ${figure.lines.length} lines');
		for (i in 0...figure.lines.length) {
			line_clear(figure.lines[i]);
		}
		trace('cleared figure');
		trace('has remaining lines ${figure.lines.length}');
		trace('has remaining points ${figure.model.length}');
	}

	public function set_active_figure(direction:Int) {
		clear_figure();
		var index_next = (model_index + direction);
		index_next = (index_next % file.models.length + file.models.length) % file.models.length;
		trace('next figure $index_next');

		model_index = index_next;
		trace('show $model_index');

		figure = map_figure(file.models[model_index]);
	}

	public function add_new_figure() {
		clear_figure();
		file.models.push({
			lines: []
		});

		model_index = file.models.length - 1;
		trace('new figure $model_index');

		figure = map_figure(file.models[model_index]);
	}

	public function line_clear(line:AbstractLine) {
		trace('designer clean line $line');
		line.erase();
	}

	function map_line(from:Vector, to:Vector):LineModel {
		return {
			from: translation.view_to_model_point(from),
			to: translation.view_to_model_point(to)
		}
	}

	public function save_state(convert_from_screen_positions:Bool = false) {
		trace("save");
		if (convert_from_screen_positions) {
			var convert_line:LineModel->LineModel = line -> {
				from: translation.view_to_model_point(line.from),
				to: translation.view_to_model_point(line.to)
			}

			var convert_model:Model->Model = model -> {
				lines: model.lines.map(line -> convert_line(line))
			}

			var models:Array<Model> = file.models.map(model -> convert_model(model));

			Disk.file_write_models(models, 'converted_' + state_file_path);
		} else {
			Disk.file_write_models(file.models, state_file_path);
		}
	}

	public function start_drawing_line(point:Vector) {
		isDrawingLine = true;
		var x = round_to_nearest(point.x, size_segment) - size_segment_half;
		var y = round_to_nearest(point.y, size_segment) - size_segment_half;
		var line:AbstractLine = graphics.make_line(x, y, x, y, 0xFFFFFFff);
		figure.lines.push(line);
		trace('start_drawing_line ${x} ${y}');
	}

	public function stop_drawing_line(point:Vector) {
		isDrawingLine = false;
		trace('stop_drawing_line ${point.x} ${point.y}');
		var line = figure.line_newest();
		line.point_to.x = round_to_nearest(point.x, size_segment) - size_segment_half;
		line.point_to.y = round_to_nearest(point.y, size_segment) - size_segment_half;
		figure.model.push(map_line(line.point_from, line.point_to));
		// save_state();
		for (line in figure.lines) {
			trace('${line.point_from.x},${line.point_from.y} -> ${line.point_to.x},${line.point_to.y}');
		}
	}

	function round_to_nearest(value:Float, interval:Float):Float {
		return Math.ceil(value / interval) * interval;
	}
}

@:structInit
class Figure {
	public var model:Array<LineModel>;
	public var lines:Array<AbstractLine>;

	public function line_newest():AbstractLine {
		return lines[lines.length - 1];
	}
}
