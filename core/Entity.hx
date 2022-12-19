import Models;
import GraphicsAbstract;
using Vector;

class Entity {
	public var motion(default, null):MotionComponent;
	var lines:Polygon;
	public var weight:Float = 250;
	public var rotation:Float = 0;
	var scale = 6;
	var rotation_direction:Int = 0;
	var rotation_speed:Float;
	var model_points:Array<Vector>;
	var lines_points:Array<Vector>;

	public function new(model:Array<Vector>, x:Int, y:Int, rotation_speed:Float, make_polygon:PolygonFactory) {
		// set up motion
		motion = new MotionComponent(x, y);
		this.rotation_speed = rotation_speed;
		rotation_direction = Math.random() > 0.5 ? -1 : 1;
		// set up lines 
		model_points = model;
		final color = 0xFF00FFff;
		lines = make_polygon(model_points, color);
		lines_points = lines.points();
	}

	public function update(elapsed_seconds:Float) {
		motion.compute_motion(elapsed_seconds);
		rotation = rotation + (rotation_speed * rotation_direction);
	}

	public function set_color(color:RGBA){
		lines.color = color;
	}

	public function draw(){
		lines.draw(motion.position.x, motion.position.y, rotation, scale);
		lines_points = lines.points();
	}
	
	public function set_rotation_direction(direction:Int) {
		rotation_direction = direction;
	}

	public function collision_points():Array<Vector>{
		return lines.points();
	}
	
	public function overlaps_polygon(model:Array<Vector>):Bool{
		
		for(point in model){
			if(lines_points.polygon_overlaps_point(point)){
				return true;
			}
		}
		return false;
	}

}
