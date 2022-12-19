import Models;
import GraphicsAbstract;

using Vector;

class Asteroid {
	public var motion(default, null):MotionComponent;
	var entity:Entity;
	var weight:Float = 250;
	var scale = 6;

	public function new(x:Int, y:Int, make_polygon:PolygonFactory) {
		// set up shape model
		var model = new AsteroidModel(x, y, 7, 6, 8);
		var white:Int = 0xFF00FFff;
		entity = new Entity(model.points, x, y, 0.005, make_polygon);
		entity.set_rotation_direction(Math.random() > 0.5 ? -1 : 1);
	}

	public function update(elapsed_seconds:Float) {
		entity.update(elapsed_seconds);
	}

	public function draw() {
		entity.draw();
	}

	public function overlaps_polygon(model:Array<Vector>):Bool {
		return entity.overlaps_polygon(model);
	}
}
