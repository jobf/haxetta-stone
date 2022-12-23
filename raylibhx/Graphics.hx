import Rl;
import GraphicsAbstract;

class Graphics extends GraphicsAbstract {
	var lines:Array<AbstractLine> = [];

	public function draw() {
		for (line in lines) {
			line.draw();
		}
	}

	public function make_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:RGBA):AbstractLine {
		lines.push(new Line({
			x: from_x,
			y: from_y
		}, {
			x: to_x,
			y: to_y
		}, color));
		return lines[lines.length -1];
	}

	public function make_particle(x:Float, y:Float, size:Int, color:RGBA, lifetime_seconds:Float):AbstractParticle {
		return new Particle(Std.int(x), Std.int(y), size, color, lifetime_seconds);
	}
}

class Line extends AbstractLine {
	public function new(point_from:Vector, point_to:Vector, color:RGBA) {
		super(point_from, point_to, color);
	}

	public function draw():Void {
		// if (point_to != null) {
		// 	this.point_to.x = point_to.x;
		// 	this.point_to.y = point_to.y;
		// }
		// if (color != null) {
		// 	this.color = color;
		// }
		
		var from_x = Std.int(this.point_from.x);
		var from_y = Std.int(this.point_from.y);
		var to_x = Std.int(this.point_to.x);
		var to_y = Std.int(this.point_to.y);
		color_raylib = to_raylib_color(color);
		Rl.drawLine(from_x, from_y, to_x, to_y, color_raylib);
	}

	var color_raylib:Color;
}

class Particle extends AbstractParticle {
	var color_raylib:Color;

	public function new(x:Int, y:Int, size:Int, color:RGBA, lifetime_seconds:Float) {
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

function to_raylib_color(color:RGBA):RlColor {
	return RlColor.create(color.r, color.g, color.b, color.a);
}
