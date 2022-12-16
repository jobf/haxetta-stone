import Peote.Rectangle;
import peote.view.Color;
import Physics;
using Physics.MotionComponentLogic;


class Emitter {
	/** starting x position of particles **/
	var x:Int;
	
	/** starting y position of particles **/
	var y:Int;

	/** pool of particles for recycling **/
	var particles:Array<Particle>;

	/** size of particle pool **/
	var maximum_particles:Int = 100;
	
	/** amount of time between particle emissions emission **/
	public var seconds_between_particles:Float = 0.003;
	var seconds_until_next_particle:Float = 0;

	/** lowest x speed used when determining random x acceleration **/
	public var x_speed_minimum:Float = 100;

	/** highest x speed used when determining random y acceleration **/
	public var x_speed_maximum:Float = 1000;

	/** lowest y speed used when determining random y acceleration **/
	public var y_speed_minimum:Float = 400;

	/** highest y speed used when determining random y acceleration **/
	public var y_speed_maximum:Float = 1000;

	/** width and height of particles **/
	public var particle_size:Float = 4;

	/** how many seconds the particle will be active before it can be recycled **/
	public var particle_life_seconds:Float = 2.5;

	/** if the emitter should emit particles or not **/
	public var is_emitting:Bool = false;

	public var rotation:Float = 0;

	public function new(x:Int, y:Int) {
		particles = [];
		this.x = x;
		this.y = y;
	}

	public function update(elapsed_seconds:Float) {
		for (p in particles) {
			p.update(elapsed_seconds);
		}

		if(!is_emitting){
			// do not make particles when not emitting
			return;
		}

		if (seconds_until_next_particle <= 0) {
			if (particles.length < maximum_particles) {
				make_particle();
			} else {
				recycle_particle();
			}
			seconds_until_next_particle = seconds_between_particles;
		} else {
			seconds_until_next_particle = seconds_until_next_particle - elapsed_seconds;
		}
	}

	function make_particle() {
		final color:Color = 0xBF8040ff;
		final alpha_min = 80;
		// randomise alpha
		color.a = Std.int((Math.random() * 255) + alpha_min);
		var particle = new Particle(x, y, Std.int(particle_size), color, particle_life_seconds);
		set_trajectory(particle);
		particles.push(particle);
	}

	function recycle_particle() {
		for (p in particles) {
			if (p.is_expired) {
				p.reset_to(x, y, Std.int(particle_size));
				set_trajectory(p);
				// break out of the loop because only want to recycle one particle
				break;
			}
		}
	}

	function set_trajectory(particle:Particle){
		// some variation for x and y
		var x_speed = (x_speed_maximum * Math.random()) + x_speed_minimum;
		var y_speed = (y_speed_maximum * Math.random()) + y_speed_minimum;

		// calculate acceleration based on rotation
		var x_acceleration = Math.sin(rotation) * -x_speed;
		var y_acceleration = -Math.cos(rotation) * -y_speed;

		particle.set_trajectory(x_acceleration, y_acceleration);
	}

	public function set_position(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}
}

class Particle {
	var size:Int;
	var color:Color;
	var motion:MotionComponent;
	var lifetime_seconds:Float;
	var lifetime_seconds_remaining:Float;
	var element:Rectangle;

	public var is_expired(default, null):Bool;

	public function new(x:Int, y:Int, size:Int, color:Color, lifetime_seconds:Float) {
		this.color = color;
		this.size = size;
		this.lifetime_seconds = lifetime_seconds;
		this.lifetime_seconds_remaining = lifetime_seconds;
		is_expired = false;
		this.motion = new MotionComponent(x, y);
		this.element = Peote.make_rectangle(x, y, size, size, color);
	}

	public function update(elapsed_seconds:Float) {
		if (!is_expired) {
			// only run this logic if the particle is not expired

			// calculate new position
			motion.compute_motion(elapsed_seconds);
			element.x = motion.position.x;
			element.y = motion.position.y;

			// enough enough time has passed, expire the particle so it can be recycled
			lifetime_seconds_remaining -= elapsed_seconds;
			if (lifetime_seconds_remaining <= 0) {
				// change expired state so update logic is no longer run
				is_expired = true;
			}
		}
	}

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
