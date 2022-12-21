import Engine;

class Editor{
	var bounds_view:RectangleGeometry;
	var x_center:Int;
	var y_center:Int;
	var points_in_editor_x = 10;
	var points_in_editor_y = 10;
	var bounds_width_half:Float;
	var bounds_height_half:Float;

	public function new(bounds_view:RectangleGeometry, points_in_editor_x:Int=3, points_in_editor_y:Int=3) {
		this.bounds_view = bounds_view;
		this.points_in_editor_x = points_in_editor_x;
		this.points_in_editor_y = points_in_editor_y;
		x_center = Std.int(bounds_view.width * 0.5);
		y_center = Std.int(bounds_view.height * 0.5);
		bounds_width_half = bounds_view.width * 0.5;
		bounds_height_half = bounds_view.height * 0.5;
	}

	public function view_to_editor_point(point_in_view:Vector):Vector{
		var offset_point:Vector = {
			x: point_in_view.x - bounds_width_half,
			y: point_in_view.y - bounds_height_half
		}

		var transformed_point:Vector = {
			x: (offset_point.x / bounds_view.width) * points_in_editor_x,
			y: (offset_point.y / bounds_view.height) * points_in_editor_y,
		}

		// trace('position offset ${transformed_point.x},${transformed_point.y}');
		
		return transformed_point;
	}
}