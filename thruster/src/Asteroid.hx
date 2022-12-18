import peote.view.Color;
import Models;
import Peote.Polygon;
using Vector;

class Asteroid {
	public var motion(default, null):MotionComponent;
	var shape:Polygon;
	var weight:Float = 250;
	var rotation:Float = 0;
	var scale = 6;
	var rotation_direction:Int = 0;
	var model:AsteroidModel;
	var shape_points:Array<Vector>;

	public function new(x:Int, y:Int) {
		// set up motion
		motion = new MotionComponent(x, y);
		rotation_direction = Math.random() > 0.5 ? -1 : 1;
		// set up shape 
		model = new AsteroidModel(x, y, 7, 6, 8);
		shape = Peote.make_polygon(model.points, Color.MAGENTA);
		shape_points = shape.points();
	}

	public function update(elapsed_seconds:Float) {
		rotation = rotation + (0.005 * rotation_direction);
		motion.compute_motion(elapsed_seconds);

	}

	public function draw(){
		shape.transform(motion.position.x, motion.position.y, rotation, scale);
		shape_points = shape.points();
	}
	
	public function set_rotation_direction(direction:Int) {
		rotation_direction = direction;
	}
	
	public function overlaps_polygon(model:Array<Vector>):Bool{
		
		for(point in model){
			if(shape_points.polygon_overlaps_point(point)){
				return true;
			}
		}
		return false;
	}

}
