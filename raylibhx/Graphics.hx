import Rl;
import GraphicsAbstract;

class Raylib{
	public static function make_polygon(model:Array<Vector>, color:Int):Polygon {
		return {
			model: model,
			color: color,
			lines: [ for (point in model) new Line(point, color)]
		}
	}

	public static function make_particle(x:Float, y:Float, color:Int, size:Int, lifetime_seconds:Float):AbstractParticle {
		return new Particle(Std.int(x), Std.int(y), size, color, lifetime_seconds);
	}
}

class Line extends AbstractLine {
	public function new(point_from:Vector, color:Int) {
		super(point_from);
	}

	public function draw(point_to:Vector, color:RGBA):Void {
		var from_x = Std.int(point_from.x);
		var from_y = Std.int(point_from.y);
		var to_x = Std.int(point_to.x);
		var to_y = Std.int(point_to.y);
		color_raylib = to_raylib_color(color);
		Rl.drawLine(from_x, from_y, to_x, to_y, color_raylib);
	}

	var color_raylib:Color;
}

class Particle extends AbstractParticle{
	var color_raylib:Color;

	public function new(x:Int, y:Int, size:Int, color:RGBA, lifetime_seconds:Float){
		super(x, y, size, color, lifetime_seconds);
		color_raylib = to_raylib_color(color);
	}

	public function draw() {
		var x = Std.int(motion.position.x);
		var y = Std.int(motion.position.y);
		color_raylib = to_raylib_color(color);
		Rl.drawRectangle(x, y, size, size, color_raylib);
	}
}

function to_raylib_color(color:RGBA):RlColor{
	return RlColor.create(color.r,
		color.g,
		color.b,
		color.a
	);
}