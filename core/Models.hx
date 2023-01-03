import Vector;

@:structInit
class FigureModel{
	public var lines:Array<LineModel>;
}

@:structInit
class LineModel{
	public var from:Vector;
	public var to:Vector;
}

class IsoscelesModel {
	public var a_point:Vector;
	public var b_point:Vector;
	public var c_point:Vector;
	public var points:Array<Vector>;

	public function new() {
		a_point = {x: 0.0, y: -6.0};
		b_point = {x: -3.0, y: 3.0};
		c_point = {x: 3.0, y: 3.0};
		points = [a_point, b_point, c_point];
	}
}

class AsteroidModel {
	public var points:Array<Vector>;
	public var center:Vector;

	public function new(x_center:Int, y_center:Int, numberOfNodes:Int, minRadius:Float, maxRadius:Float) {
		center = {
			x: x_center,
			y: y_center,
		}

		var angleStep = Math.PI * 2 / numberOfNodes;

		points = [
			for (i in 0...numberOfNodes) {
				// This is the angle we want if all parts are equally spaced
				var targetAngle = angleStep * i;

				// add a random factor to the angle, which is +- 25% of the angle step
				var angle = targetAngle + (next_float() - 0.5) * angleStep * 0.25;

				// make the radius random but within minRadius to maxRadius
				var radius = minRadius + next_float() * (maxRadius - minRadius);
				// calculate x and y positions of the part point
				{
					x: Math.cos(angle) * radius,
					y: Math.sin(angle) * radius,
				}
			}
		];
	}
}

function next_float():Float {
	return Math.random();
}