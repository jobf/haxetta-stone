import Particles;
import peote.view.Color;
import Geometry;
import Peote.Polygon;
import Physics;

using Physics.MotionComponentLogic;

class Ship {
	public var motion(default, null):MotionComponent;

	var triangle:Polygon;
	var gravity:Float = 250;
	var rotation:Float = 0;
	var thruster_position:Point;
	var scale = 6;
	var particles_thruster:Emitter;

	public function new(x:Int, y:Int) {
		// set up motion
		motion = new MotionComponent(x, y);
		// set deceleration for slowing down the ship when notr accelerating
		motion.deceleration.x = gravity * 0.5;
		motion.deceleration.y = gravity * 0.5;

		// set up shape model
		var model = new IsoscelesModel();
		triangle = Peote.make_polygon(model.points, Color.MAGENTA);

		// set up particles
		thruster_position = {x:  0.0, y: 3.0 };
		var x_particles = Std.int(thruster_position.x);
		var y_particles = Std.int(thruster_position.y);
		particles_thruster = new Emitter(x_particles, y_particles);
	}

	public function update(elapsed_seconds:Float) {
		rotation = rotation + (0.05 * rotation_direction);
		motion.compute_motion(elapsed_seconds);
		triangle.transform(motion.position.x, motion.position.y, rotation, scale);

		var rotation_sin = Math.sin(rotation);
		var rotation_cos = Math.cos(rotation);
		
		// rotate
		var thruster_position_translated:Point = {
			x: thruster_position.x * rotation_cos - thruster_position.y * rotation_sin,
			y: thruster_position.x * rotation_sin + thruster_position.y * rotation_cos
		};

		// scale
		thruster_position_translated.x = thruster_position_translated.x * scale;
		thruster_position_translated.y = thruster_position_translated.y * scale;

		// transform
		thruster_position_translated.x = thruster_position_translated.x + motion.position.x;
		thruster_position_translated.y = thruster_position_translated.y + motion.position.y;
		
		var x_particles = Std.int(thruster_position_translated.x);
		var y_particles = Std.int(thruster_position_translated.y);

		particles_thruster.set_position(x_particles, y_particles);
		particles_thruster.update(elapsed_seconds);
		particles_thruster.rotation = rotation;
	}

	public function set_acceleration(should_enable:Bool):Void {
		if (should_enable) {
			particles_thruster.is_emitting = true;
			// give ship some thrust, using rotation to determine direction
			motion.acceleration.x = Math.sin(rotation) * gravity;
			motion.acceleration.y = -Math.cos(rotation) * gravity;
		} else {
			particles_thruster.is_emitting = false;
			// stop accelerating, so deceleration can come into effect
			motion.acceleration.x = 0;
			motion.acceleration.y = 0;
		}
	}

	public function set_brakes(should_enable:Bool) {
		if (should_enable) {
			// motion.acceleration.x = 0;
			// motion.acceleration.y = 0;
			motion.deceleration.x = gravity * 2.0;
			motion.deceleration.y = gravity * 2.0;
		} else {
			motion.deceleration.x = gravity * 0.5;
			motion.deceleration.y = gravity * 0.5;
		}
	}

	var rotation_direction:Int = 0;

	public function set_rotation_direction(direction:Int) {
		rotation_direction = direction;
	}
}
