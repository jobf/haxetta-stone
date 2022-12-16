
@:structInit
class Point {
	public var x:Float;
	public var y:Float;
}

class IsoscelesModel {
	public var a_point:Point;
	public var b_point:Point;
	public var c_point:Point;
	public var points:Array<Point>;

	public function new() {
		a_point = {x: 0.0, y: -6.0};
		b_point = {x: -3.0, y: 3.0};
		c_point = {x: 3.0, y: 3.0};
		points = [a_point, b_point, c_point];
	}
}
