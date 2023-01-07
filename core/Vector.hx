
@:structInit
class Vector {
	public var x:Float;
	public var y:Float;
}

class MotionComponent {
	public function new(x:Int, y:Int) {
		position = {
			x: x,
			y: y
		}

		position_previous = {
			x: x,
			y: y
		}

		velocity = {
			x: 0,
			y: 0
		}

		velocity_maximum = {
			x: 0,
			y: 0
		}

		acceleration = {
			x: 0,
			y: 0
		}

		deceleration = {
			x: 0,
			y: 0
		}
	}

	/**
	 * Current x,y position in world space
	**/
	public var position:Vector;

	/**
	 * Previous x,y position in world space
	**/
	public var position_previous:Vector;

	/**
	 * Current x,y velocity
	**/
	public var velocity:Vector;

	/**
	 * Maximum x,y velocity permitted
	**/
	public var velocity_maximum:Vector;

	/**
	 * How much velocity will speed up on x,y axes
	**/
	public var acceleration:Vector;

	/**
	 * How much velocity will slow down on x,y axes
	 * Note: only takes effect when Acceleration is zero
	**/
	public var deceleration:Vector;
}

class MotionComponentLogic {
	/**
	 * Updates the speed and position of the MotionComponent 
	 * 2 deltas are calculated per axis to "help with higher fidelity framerate-independent motion.
	 * Based on FlxObject UpdateMotion https://github.com/HaxeFlixel/flixel/blob/dev/flixel/FlxObject.hx#L882
	 * @param motion				The motion component to be updated
	 * @param elapsed_seconds	The amount of time passed since last update frame
	**/
	public static function compute_motion(motion:MotionComponent, elapsed_seconds:Float) {
		// update x axis position and speed
		var vel_delta = 0.5 * (compute_axis(motion.velocity.x, motion.acceleration.x, motion.deceleration.x, motion.velocity_maximum.x, elapsed_seconds)
			- motion.velocity.x);
		motion.velocity.x = motion.velocity.x + vel_delta;
		var movement_delta = motion.velocity.x * elapsed_seconds;
		// keep record of previous position before setting new position based on the movement delta
		motion.position_previous.x = motion.position.x;
		motion.position.x = motion.position.x + movement_delta;

		// update y axis position and speed
		var vel_delta = 0.5 * (compute_axis(motion.velocity.y, motion.acceleration.y, motion.deceleration.y, motion.velocity_maximum.y, elapsed_seconds)
			- motion.velocity.y);
		motion.velocity.y = motion.velocity.y + vel_delta;
		var movement_delta = motion.velocity.y * elapsed_seconds;
		// keep record of previous position before setting new position based on the movement delta
		motion.position_previous.y = motion.position.y;
		motion.position.y = motion.position.y + movement_delta;
	}

	/**
	 * Takes a starting velocity and some other factors and returns an adjusted velocity
	 * Based on FlxVelocity ComputeVelocity - https://github.com/HaxeFlixel/flixel/blob/dev/flixel/math/FlxVelocity.hx#L223
	 * @param	velocity				The velocity that should be adjusted
	 * @param	acceleration		Rate at which the velocity is changing.
	 * @param	deceleration		How much the velocity changes if Acceleration is not set.
	 * @param	velocity_maximum	An absolute value cap for the velocity (0 for no cap).
	 * @param	elapsed_seconds	The amount of time passed since last update frame
	 * @return	The adjusted Velocity value.
	**/
	static function compute_axis(velocity:Float, acceleration:Float, deceleration:Float, velocity_maximum:Float, elapsed_seconds:Float):Float {
		// velocity and acceleration are bipolar so can either be
		// - positive : moving up the axis - (x : right, y : down)
		// - negative : moving down the axis - (x : left, y : up)
		if (acceleration != 0) {
			// if acceleration is a non zero amount
			// it should have an effect on velocity
			var speed_up_by = acceleration * elapsed_seconds;
			// acceleration can cause the motion to reverse direction
			// (e.g. -2 + 10 = 8, 2 + -10 = -8)
			velocity += speed_up_by;
		} else if (deceleration != 0) {
			// if acceleration IS zero then deceleration can be applied
			// when deceleration is a non zero amount
			var slow_down_by = deceleration * elapsed_seconds;
			// applying enough deceleration to velocity could cross zero
			// which would cause the motion to tracel in the opposite direction
			// however deceleration is only used to slow motion down
			// it would be odd to have the motion change direction when slowing down
			// so some extra logic is needed

			if (velocity - slow_down_by > 0) {
				// only slow the motion if staying the same side of zero (e.g. direction does not change)
				velocity -= slow_down_by;
			} else if (velocity + slow_down_by < 0) {
				// only slow the motion if staying the same side of zero (e.g. direction does not change)
				velocity += slow_down_by;
			} else {
				// this branch is only reached when direction would change
				// in this case stop the motion by setting velocity to 0
				velocity = 0;
			}
		}

		// final checks to ensure that velocity did not increase/decrease
		// beyond the maximum velocity
		if ((velocity != 0) && (velocity_maximum != 0)) {
			if (velocity > velocity_maximum) {
				velocity = velocity_maximum;
			} else if (velocity < -velocity_maximum) {
				velocity = -velocity_maximum;
			}
		}
		return velocity;
	}
}

class VectorLogic {
	public static function point_overlaps_circle(point:Vector, target:Vector, radius:Float){
		var distance = distance_to(point, target);
		return distance <= radius;
	}

	public static function polygon_overlaps_point(polygon_model:Array<Vector>, target:Vector):Bool {
		var collision = false;
		for (a in 0...polygon_model.length) {
			var point_a = polygon_model[a % polygon_model.length];
			var point_b = polygon_model[(a + 1) % polygon_model.length];
			if (((point_a.y >= target.y && point_b.y < target.y) || (point_a.y < target.y && point_b.y >= target.y))
				&& (target.x < (point_b.x - point_a.x) * (target.y - point_a.y) / (point_b.y - point_a.y) + point_a.x)) {
				collision = !collision;
			}
		}
		return collision;
	}

	public static function distance_to(point_from:Vector, point_to:Vector):Float
	{
		var a = point_to.x - point_from.x;
		var b = point_to.y - point_from.y;

		return Math.sqrt(a * a + b * b);
	}

	public static function line_overlaps_point(target:Vector, line_from:Vector, line_to:Vector):Bool {
		var collision = false;
		// get distance from the point to the two ends of the line
		var d1 = VectorLogic.distance_to(target, line_from);
		var d2 = VectorLogic.distance_to(target, line_to);

		// get the length of the line
		var lineLen = VectorLogic.distance_to(line_from, line_to);

		// since floats are so minutely accurate, add
		// a little buffer zone that will give collision
		var buffer = 0.3; // higher # = less accurate

		// if the two distances are equal to the line's
		// length, the point is on the line!
		// note we use the buffer here to give a range,
		// rather than one #
		if (d1 + d2 >= lineLen - buffer && d1 + d2 <= lineLen + buffer) {
			collision = true;
		}
		return collision;
	}

	public static function line_overlaps_line(line_from_a:Vector, line_to_a:Vector, line_from_b:Vector, line_to_b:Vector):Bool {
		var collision = false;
		  // calculate the distance to intersection point
		var uA = ((line_to_b.x-line_from_b.x)*(line_from_a.y-line_from_b.y) - (line_to_b.y-line_from_b.y)*(line_from_a.x-line_from_b.x)) / ((line_to_b.y-line_from_b.y)*(line_to_a.x-line_from_a.x) - (line_to_b.x-line_from_b.x)*(line_to_a.y-line_from_a.y));
		var uB = ((line_to_a.x-line_from_a.x)*(line_from_a.y-line_from_b.y) - (line_to_a.y-line_from_a.y)*(line_from_a.x-line_from_b.x)) / ((line_to_b.y-line_from_b.y)*(line_to_a.x-line_from_a.x) - (line_to_b.x-line_from_b.x)*(line_to_a.y-line_from_a.y));
		if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
			collision = true;
		}
		// get distance from the point to the two ends of the line
		// // var d1 = VectorLogic.distance_to(target, line_from);
		// // var d2 = VectorLogic.distance_to(target, line_to);

		// // // get the length of the line
		// // var lineLen = VectorLogic.distance_to(line_from, line_to);

		// // since floats are so minutely accurate, add
		// // a little buffer zone that will give collision
		// var buffer = 0.3; // higher # = less accurate

		// // if the two distances are equal to the line's
		// // length, the point is on the line!
		// // note we use the buffer here to give a range,
		// // rather than one #
		// if (d1 + d2 >= lineLen - buffer && d1 + d2 <= lineLen + buffer) {
		// 	collision = true;
		// }
		return collision;
	}

	public static function vector_transform(vector:Vector, origin:Vector, scale:Float, x:Float, y:Float, ?rotation_sin:Float, ?rotation_cos:Float, ?rotation:Float):Vector {
		// rotate
		var rotation_sin = rotation_sin == null ? Math.sin(rotation) : rotation_sin;
		var rotation_cos = rotation_cos == null ? Math.cos(rotation) : rotation_cos;

		var x_origin = vector.x + origin.x;
		var y_origin = vector.y + origin.y;

		var transformed:Vector = {
			x: x_origin * rotation_cos - y_origin * rotation_sin,
			y: x_origin * rotation_sin + y_origin * rotation_cos
		};

		// scale
		transformed.x = transformed.x * scale;
		transformed.y = transformed.y * scale;

		// transform

		transformed.x = transformed.x + x;
		transformed.y = transformed.y + y;

		transformed.x = transformed.x - x_origin;
		transformed.y = transformed.y - y_origin;

		return transformed;
	}
}
