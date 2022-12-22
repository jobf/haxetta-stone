import GraphicsAbstract;

using Vector;

class Emitter {
	/** starting x position of particles **/
	var x:Int;

	/** starting y position of particles **/
	var y:Int;

	/** pool of particles for recycling **/
	var particles:Array<AbstractParticle>;

	/** size of particle pool **/
	var maximum_particles:Int = 30;

	/** amount of time between particle emissions emissi on **/
	public var seconds_between_particles:Float = 0.097;

	var seconds_until_next_particle:Float = 0;

	/** lowest x speed used when determining random x acceleration **/
	public var x_speed_minimum:Float = 20;

	/** highest x speed used when determining random y acceleration **/
	public var x_speed_maximum:Float = 30;

	/** lowest y speed used when determining random y acceleration **/
	public var y_speed_minimum:Float = 20;

	/** highest y speed used when determining random y acceleration **/
	public var y_speed_maximum:Float = 30;

	/** width and height of particles **/
	public var particle_size:Float;

	/** how many seconds the particle will be active before it can be recycled **/
	public var particle_life_seconds:Float = 0.495;

	/** if the emitter should emit particles or not **/
	public var is_emitting:Bool = false;

	public var rotation:Float = 0;

	var graphics:GraphicsAbstract;

	public function new(x:Int, y:Int, graphics:GraphicsAbstract) {
		particles = [];
		this.x = x;
		this.y = y;
		this.particle_size = 14;
		this.graphics = graphics;
	}

	public function update(elapsed_seconds:Float) {
		for (p in particles) {
			p.update(elapsed_seconds);
		}

		if (!is_emitting) {
			// do not make particles when not emitting
			return;
		}

		if (seconds_until_next_particle <= 0) {
			if (particles.length < maximum_particles) {
				create_particle();
			} else {
				recycle_particle();
			}
			seconds_until_next_particle = seconds_between_particles;
		} else {
			seconds_until_next_particle = seconds_until_next_particle - elapsed_seconds;
		}
	}

	function create_particle() {
		var particle = graphics.make_particle(x, y, Std.int(particle_size), variateColor(), particle_life_seconds);
		particle.set_color(variateColor());
		set_trajectory(particle);
		particles.push(particle);
	}

	function recycle_particle() {
		for (p in particles) {
			if (p.is_expired) {
				p.reset_to(x, y, Std.int(particle_size), variateColor());
				set_trajectory(p);
				// break out of the loop because only want to recycle one particle
				break;
			}
		}
	}

	function variateColor():RGBA {
		final color:RGBA = 0xBF8010ff;
		final alpha_min = 30;
		// randomise alpha
		color.a = Std.int((Math.random() * 70) + alpha_min);
		return color;
	}

	function set_trajectory(particle:AbstractParticle) {
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

	public function draw() {
		for (particle in particles) {
			if(particle.is_expired){
				particle.set_color(0x00000000);
			}
			particle.draw();
		}
	}
}
