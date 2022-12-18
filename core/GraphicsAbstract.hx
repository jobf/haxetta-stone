import Engine;

using Vector;

abstract class AbstractLine {
	public var point_from:Vector;

	public function new(point_from:Vector) {
		this.point_from = point_from;
	}
	
	abstract public function draw(point_to:Vector, color:Int):Void;
}

@:structInit
class Polygon {
	var lines:Array<AbstractLine>;

	public var model(default, null):Array<Vector>;

	var rotation_sin:Float = 0;
	var rotation_cos:Float = 0;

	public var color:Int;

	public function draw(x:Float, y:Float, rotation:Float, scale:Float) {
		rotation_sin = Math.sin(rotation);
		rotation_cos = Math.cos(rotation);

		for (n => line in lines) {
			line.point_from = model[n].vector_transform(scale, x, y, rotation_sin, rotation_cos);
		}

		for (a in 0...lines.length) {
			lines[a % lines.length].draw(lines[(a + 1) % lines.length].point_from, color);
		}
	}

	public function points():Array<Vector>{
		return lines.map(line -> line.point_from);
	}
}

abstract class AbstractParticle {
	var size:Int;
	var color:Int;
	var motion:MotionComponent;
	var lifetime_seconds:Float;
	var lifetime_seconds_remaining:Float;

	public var is_expired(default, null):Bool;

	public function new(x:Int, y:Int, size:Int, color:Int, lifetime_seconds:Float) {
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

			// enough enough time has passed, expire the particle so it can be recycled
			lifetime_seconds_remaining -= elapsed_seconds;
			if (lifetime_seconds_remaining <= 0) {
				// change expired state so update logic is no longer run
				is_expired = true;
			}
		}
		draw();

	}

	abstract public function draw():Void;

	public function set_trajectory(x_acceleration:Float, y_acceleration:Float) {
		motion.acceleration.x = x_acceleration;
		motion.acceleration.y = y_acceleration;
	}

	public function reset_to(x:Int, y:Int, size:Int) {
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
	}
}

typedef ParticleFactory = (x:Float, y:Float, size:Int, color:Int, lifetime_seconds:Float) -> AbstractParticle;
typedef PolygonFactory = (model:Array<Vector>, color:Int) -> Polygon;

@:structInit
class GraphicsAbstract{
	public var make_polygon:PolygonFactory;
	public var make_particle:ParticleFactory;
	public var viewport_bounds:RectangleGeometry;
}

abstract ColorAbstract(Int) from Int to Int from UInt to UInt
{
	inline function new(rgba:Int) this = rgba;
	
	public var r(get,set):Int;
	public var g(get,set):Int;
	public var b(get,set):Int;
	public var a(get, set):Int;
	
	inline function get_r() return (this >> 24) & 0xff;
	inline function get_g() return (this >> 16) & 0xff;
	inline function get_b() return (this >>  8) & 0xff;
	inline function get_a() return  this & 0xff;
	
	inline function set_r(r:Int) { this = (this & 0x00ffffff) | (r<<24); return r; }
	inline function set_g(g:Int) { this = (this & 0xff00ffff) | (g<<16); return g; }
	inline function set_b(b:Int) { this = (this & 0xffff00ff) | (b<<8 ); return b; }
	inline function set_a(a:Int) { this = (this & 0xffffff00) | a; return a; }
}