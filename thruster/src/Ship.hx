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

	public function new(x:Int, y:Int) {
		// set up motion
		motion = new MotionComponent(x, y);
		// set deceleration for slowing down the ship when notr accelerating
		motion.deceleration.x = gravity * 0.5;
		motion.deceleration.y = gravity * 0.5;

		// set up shape model
		var model = new IsoscelesModel();
		triangle = Peote.make_polygon(model.points, Color.MAGENTA);
	}

	public function update(elapsed_seconds:Float) {
		rotation = rotation + (0.05 * rotation_direction);
		motion.compute_motion(elapsed_seconds);
		triangle.transform(motion.position.x, motion.position.y, rotation, scale);
	}

	public function set_acceleration(should_enable:Bool):Void {
		if (should_enable) {
			// give ship some thrust, using rotation to determine direction
			motion.acceleration.x = Math.sin(rotation) * gravity;
			motion.acceleration.y = -Math.cos(rotation) * gravity;
		} else {
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
