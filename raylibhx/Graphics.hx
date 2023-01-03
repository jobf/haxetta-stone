import Rl;
import GraphicsAbstract;

class Graphics extends GraphicsAbstract {
	var lines:Array<AbstractLine> = [];
	var fills:Array<AbstractFillRectangle> = [];

	public function draw() {
		for (line in lines) {
			line.draw();
		}
		for (fill in fills) {
			fill.draw();
		}
	}

	public function make_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:RGBA):AbstractLine {
		trace('make_line $from_x $from_y $to_x $to_y');
		lines.push(new Line({
			x: from_x,
			y: from_y
		}, {
			x: to_x,
			y: to_y
		},
		color,
		line -> line_erase(line)));
		return lines[lines.length - 1];
	}

	function line_erase(line:Line) {
		lines.remove(line);
	}

	public function make_particle(x:Float, y:Float, size:Int, color:RGBA, lifetime_seconds:Float):AbstractParticle {
		return new Particle(Std.int(x), Std.int(y), size, color, lifetime_seconds);
	}

	public function make_fill(x:Int, y:Int, width:Int, height:Int, color:RGBA):AbstractFillRectangle {
		fills.push(new Fill(x, y, width, height, color));
		return fills[fills.length -1];
	}
}

class Line extends AbstractLine {
	var remove_from_buffer:Line->Void;
	public function new(point_from:Vector, point_to:Vector, color:RGBA, remove_from_buffer:Line->Void) {
		super(point_from, point_to, color);
		this.remove_from_buffer = remove_from_buffer;
	}

	public function draw():Void {
		var from_x = Std.int(this.point_from.x);
		var from_y = Std.int(this.point_from.y);
		var to_x = Std.int(this.point_to.x);
		var to_y = Std.int(this.point_to.y);
		color_raylib = to_raylib_color(color);
		Rl.drawLine(from_x, from_y, to_x, to_y, color_raylib);
	}

	var color_raylib:Color;

	public function erase() {
		remove_from_buffer(this);
	}
}

class Fill extends AbstractFillRectangle {
	var color_raylib:Color;

	public function draw() {
		var x = Std.int(x - (width * 0.5));
		var y = Std.int(y - (height * 0.5));
		var w = Std.int(width);
		var h = Std.int(height);
		color_raylib = to_raylib_color(color);
		Rl.drawRectangle(x, y, w, h, color_raylib);
	}
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
