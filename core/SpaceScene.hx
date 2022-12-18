import InputAbstract;
import Controller;
import Engine;

class SpaceScene extends Scene {
	var ship:Ship;
	var obstacle:Asteroid;

	var x_center:Int;
	var y_center:Int;

	var controller:Controller;

	public function init() {
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);

		ship = new Ship(x_center, y_center, game.graphics.make_particle, game.graphics.make_polygon);
		obstacle = new Asteroid(x_center + 100, y_center + 45, game.graphics.make_polygon);
		var actions:ControllerActions = {
			// up: {
			// 	on_pressed: ()-> ship.set_brakes(true),
			// 	on_released: ()-> ship.set_brakes(false)
			// },
			right: {
				on_pressed: () -> ship.set_rotation_direction(1),
				on_released: () -> ship.set_rotation_direction(0)
			},
			left: {
				on_pressed: () -> ship.set_rotation_direction(-1),
				on_released: () -> ship.set_rotation_direction(0)
			},
			down: {
				on_pressed: () -> ship.set_acceleration(true),
				on_released: () -> ship.set_acceleration(false)
			}
		}


		controller = new Controller(actions, game.input);
	}

	public function update(elapsed_seconds:Float) {
		controller.update();
		ship.update(elapsed_seconds);

		final red:Int = 0xFF0000ff;
		final white:Int = 0xFFFFFFff;
		ship.set_color(obstacle.overlaps_polygon(ship.collision_points()) ? red : white);
		obstacle.update(elapsed_seconds);
	}

	public function draw() {
		ship.draw();
		obstacle.draw();
	}
}
