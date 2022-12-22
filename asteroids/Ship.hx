import Particles;
import Models;
import GraphicsAbstract;
using Vector;

class Ship {
	public var motion(default, null):MotionComponent;
	var entity:Entity;
	var thruster_position:Vector;
	var scale = 6;
	var particles_thruster:Emitter;
	var graphics:GraphicsAbstract;

	public function new(x:Int, y:Int, graphics:GraphicsAbstract) {
		// set up shape model
		var model = new IsoscelesModel();
		var white:Int = 0xFFFFFFff;
		entity = new Entity(model.points, x, y, 0.05, graphics);

		entity.motion.deceleration.x = entity.weight * 0.5;
		entity.motion.deceleration.y = entity.weight * 0.5;
		entity.motion.velocity_maximum.x = 60;
		entity.motion.velocity_maximum.y = 60;

		// set up particles
		thruster_position = {x:  0.0, y: 3.9 };
		var x_particles = Std.int(thruster_position.x);
		var y_particles = Std.int(thruster_position.y);


		particles_thruster = new Emitter(x_particles, y_particles, graphics);
		set_rotation_direction(0);
	}
	var ticks:Int = 0;
	public function update(elapsed_seconds:Float) {
		ticks++;
		// entity.rotation = entity.rotation + (0.05 * rotation_direction);
		var rotation_sin = Math.sin(entity.rotation);
		var rotation_cos = Math.cos(entity.rotation);
		x_acceleration =  rotation_sin * entity.weight;
		y_acceleration = -rotation_cos * entity.weight;
		steer();
		final offset_max:Float = 1.70;
		final offset_min:Float = 0.70;
		var direction = (ticks % 2 == 0) ? -1 : 1;
		var x_alter = (Math.random() * offset_max) + offset_min;
		// thruster_position.x = thruster_position.x + x_alter;
		var altered:Vector = {
			y: thruster_position.y,
			x: thruster_position.x + x_alter * direction
		}

		var thruster_position_transformed = altered.vector_transform(
			scale,
			entity.motion.position.x,
			entity.motion.position.y,
			rotation_sin,
			rotation_cos
		);
		
		var x_particles = Std.int(thruster_position_transformed.x);
		var y_particles = Std.int(thruster_position_transformed.y);
		particles_thruster.set_position(x_particles , y_particles);
		particles_thruster.rotation = entity.rotation;
		particles_thruster.update(elapsed_seconds);

		entity.update(elapsed_seconds);
	}

	public function draw(){
		particles_thruster.draw();
		entity.draw();
	}

	public function set_color(color:RGBA){
		entity.set_color(color);
	}

	var is_accelerating:Bool = false;
	var is_braking:Bool = false;

	function steer(){
		if(is_braking){
			entity.motion.acceleration.x = -x_acceleration * 0.12;
			entity.motion.acceleration.y = -y_acceleration * 0.12;
			return;
		}

		if(is_accelerating){
			// give ship some thrust, using rotation to determine direction
			entity.motion.acceleration.x = x_acceleration;
			entity.motion.acceleration.y = y_acceleration;
		}
		else{
			entity.motion.acceleration.x = 0;
			entity.motion.acceleration.y = 0;
		}
	}

	public function set_acceleration(should_enable:Bool):Void {
		is_accelerating = should_enable;
		particles_thruster.is_emitting = is_accelerating;
	}

	public function set_brakes(should_enable:Bool) {
		is_braking = should_enable;
	}

	public function set_rotation_direction(direction:Int) {
		entity.set_rotation_direction(direction);
	}

	public function collision_points():Array<Vector> {
		return entity.collision_points();
	}

	var x_acceleration(default, null):Float;

	var y_acceleration(default, null):Float;
}
