import Engine;

class Editor{
	var bounds_view:RectangleGeometry;
	var x_center:Int;
	var y_center:Int;
	var points_in_editor_x = 10;
	var points_in_editor_y = 10;

	public function new(bounds_view:RectangleGeometry, points_in_editor_x:Int=3, points_in_editor_y:Int=3) {
		this.bounds_view = bounds_view;
		this.points_in_editor_x = points_in_editor_x;
		this.points_in_editor_y = points_in_editor_y;
		x_center = Std.int(bounds_view.width * 0.5);
		y_center = Std.int(bounds_view.height * 0.5);
	}

	public function view_to_editor_point(point_in_view:Vector):Vector{
		return {
			x: point_in_view.x - x_center,
			y: point_in_view.x - y_center,
		}
	}

}