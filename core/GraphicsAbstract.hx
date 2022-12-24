import Engine;

using Vector;

abstract class AbstractLine {
	public var point_from:Vector;
	public var point_to:Vector;
	public var color:RGBA;

	public function new(point_from:Vector, point_to:Vector, color:RGBA) {
		this.point_from = point_from;
		this.point_to = point_to;
		this.color = color;
	}

	abstract public function draw():Void;
}

@:structInit
class Polygon {
	var lines:Array<AbstractLine>;

	public var model(default, null):Array<Vector>;
	public var color:RGBA;

	var rotation_sin:Float = 0;
	var rotation_cos:Float = 0;

	public function draw(x:Float, y:Float, rotation:Float, scale:Float) {
		rotation_sin = Math.sin(rotation);
		rotation_cos = Math.cos(rotation);

		for (n => line in lines) {
			line.color = color;
			line.point_from = model[n].vector_transform(scale, x, y, rotation_sin, rotation_cos);
			line.point_to = model[(n + 1) % lines.length].vector_transform(scale, x, y, rotation_sin, rotation_cos);
			line.draw();
		}
	}

	public function points():Array<Vector> {
		return lines.map(line -> line.point_from);
	}
}

abstract class AbstractParticle {
	var size:Int;
	var color:RGBA;
	var motion:MotionComponent;
	var lifetime_seconds:Float;
	var lifetime_seconds_remaining:Float;

	public var is_expired(default, null):Bool;

	public function new(x:Int, y:Int, size:Int, color:RGBA, lifetime_seconds:Float) {
		this.color = color;
		this.size = size;
		this.lifetime_seconds = lifetime_seconds;
		this.lifetime_seconds_remaining = lifetime_seconds;
		is_expired = false;
		this.motion = new MotionComponent(x, y);
	}

	public function update(elapsed_seconds:Float) {
		if (!is_expired) {
			// only run this logic if the particle is not expired

			// calculate new position
			motion.compute_motion(elapsed_seconds);

			// if enough time has passed, expire the particle so it can be recycled
			lifetime_seconds_remaining -= elapsed_seconds;
			if (lifetime_seconds_remaining <= 0) {
				// change expired state so update logic is no longer run
				is_expired = true;
				color.a = 0;
			}
		}
	}

	abstract public function draw():Void;

	public function set_trajectory(x_acceleration:Float, y_acceleration:Float) {
		motion.acceleration.x = x_acceleration;
		motion.acceleration.y = y_acceleration;
	}

	public function set_color(color:RGBA) {
		if (!is_expired) {
			this.color = color;
		} else {
			this.color.a = 0;
		}
	}

	public function reset_to(x:Int, y:Int, size:Int, color:RGBA) {
		// reset life time
		is_expired = false;
		lifetime_seconds_remaining = lifetime_seconds;

		// reset motion
		motion.acceleration.x = 0;
		motion.acceleration.y = 0;
		motion.velocity.x = 0;
		motion.velocity.y = 0;
		motion.deceleration.y = 0;

		// set new position
		motion.position.x = Std.int(x);
		motion.position.y = Std.int(y);

		// set new size
		this.size = size;

		this.color = color;
	}
}

abstract class GraphicsAbstract {
	public var viewport_bounds:RectangleGeometry;

	public function new(viewport_bounds:RectangleGeometry) {
		this.viewport_bounds = viewport_bounds;
	}

	abstract public function draw():Void;

	abstract public function make_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:RGBA):AbstractLine;

	abstract public function make_particle(x:Float, y:Float, size:Int, color:RGBA, lifetime_seconds:Float):AbstractParticle;

	public function make_polygon(model:Array<Vector>, color:RGBA):Polygon {
		var lines:Array<AbstractLine> = [];
		for (a in 0...model.length) {
			var from = model[a % model.length];
			var to = model[(a + 1) % model.length];
			lines.push(make_line(from.x, from.y, to.x, to.y, color));
		}
		return {
			model: model,
			color: color,
			lines: lines
		}
	}
}

abstract RGBA(Int) from Int to Int from UInt to UInt {
	inline function new(rgba:Int)
		this = rgba;

	public var r(get, set):Int;
	public var g(get, set):Int;
	public var b(get, set):Int;
	public var a(get, set):Int;

	inline function get_r()
		return (this >> 24) & 0xff;

	inline function get_g()
		return (this >> 16) & 0xff;

	inline function get_b()
		return (this >> 8) & 0xff;

	inline function get_a()
		return this & 0xff;

	inline function set_r(r:Int) {
		this = (this & 0x00ffffff) | (r << 24);
		return r;
	}

	inline function set_g(g:Int) {
		this = (this & 0xff00ffff) | (g << 16);
		return g;
	}

	inline function set_b(b:Int) {
		this = (this & 0xffff00ff) | (b << 8);
		return b;
	}

	inline function set_a(a:Int) {
		this = (this & 0xffffff00) | a;
		return a;
	}
}
