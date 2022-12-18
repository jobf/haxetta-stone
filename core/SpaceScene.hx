import Engine;

class SpaceScene extends Scene{
	var ship:Ship;
	var obstacle:Asteroid;

	var x_center:Int;
	var y_center:Int;

	public function init() {
		x_center = Std.int(bounds.width * 0.5);
		y_center = Std.int(bounds.height * 0.5);

		ship = new Ship(x_center, y_center, game.graphics.make_particle, game.graphics.make_polygon);
		obstacle = new Asteroid(x_center + 100, y_center + 45, game.graphics.make_polygon);
	}

	public function update(elapsed_seconds:Float) {
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