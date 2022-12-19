import Controller;
import InputAbstract;
import Engine;
import Models;

class SpaceScene extends Scene {
	var ship:Ship;
	var asteroid:Asteroid;

	var x_center:Int;
	var y_center:Int;

	var controller:Controller;

	public function init() {
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);

		ship = new Ship(x_center, y_center, game.graphics.make_particle, game.graphics.make_polygon);
		asteroid = new Asteroid(x_center + 100, y_center + 45, game.graphics.make_polygon);

		var actions:Map<Button, Action> = [
			KEY_LEFT => {
				on_pressed: () -> ship.set_rotation_direction(-1),
				on_released: () -> ship.set_rotation_direction(0)
			},
			KEY_RIGHT => {
				on_pressed: () -> ship.set_rotation_direction(1),
				on_released: () -> ship.set_rotation_direction(0)
			},
			KEY_DOWN => {
				on_pressed: () -> ship.set_acceleration(true),
				on_released: () -> ship.set_acceleration(false)
			},
		];
		
		controller = new Controller(actions, game.input);

		game.input.on_pressed = button -> {
			switch button {
				case KEY_LEFT: controller.handle_button(PRESSED, KEY_LEFT);
				case KEY_RIGHT: controller.handle_button(PRESSED, KEY_RIGHT);
				case KEY_DOWN: controller.handle_button(PRESSED, KEY_DOWN);
				case _: return;
			}
		}

		game.input.on_released = button -> {
			switch button {
				case KEY_LEFT: controller.handle_button(RELEASED, KEY_LEFT);
				case KEY_RIGHT: controller.handle_button(RELEASED, KEY_RIGHT);
				case KEY_DOWN: controller.handle_button(RELEASED, KEY_DOWN);
				case _: return;
			}
		}
	}

	public function update(elapsed_seconds:Float) {
		ship.update(elapsed_seconds);

		final red:Int = 0xFF0000ff;
		final white:Int = 0xFFFFFFff;
		ship.set_color(asteroid.overlaps_polygon(ship.collision_points()) ? red : white);
		asteroid.update(elapsed_seconds);
	}

	public function draw() {
		ship.draw();
		asteroid.draw();
	}
}
