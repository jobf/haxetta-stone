import Models;
import GraphicsAbstract;
import Editor.EditorTranslation;

using Vector;

class Entity {
	public var motion(default, null):MotionComponent;

	public var lines:Polygon;

	public var weight:Float = 250;
	public var rotation:Float = 0;

	public var scale = 1;

	var rotation_direction:Int = 0;
	var rotation_speed:Float;
	var model_points:Array<Vector>;
	var lines_points:Array<Vector>;

	public function new(model:Array<Vector>, x:Int, y:Int, rotation_speed:Float, graphics:GraphicsAbstract) {
		// set up motion
		motion = new MotionComponent(x, y);
		this.rotation_speed = rotation_speed;
		rotation_direction = Math.random() > 0.5 ? -1 : 1;
		// set up lines
		model_points = model;
		final color = 0xFF00FFff;
		lines = graphics.make_polygon(model_points, color);
		lines_points = lines.points();
	}

	public function update(elapsed_seconds:Float) {
		motion.compute_motion(elapsed_seconds);
		rotation = rotation + (rotation_speed * rotation_direction);
	}

	public function set_color(color:RGBA) {
		lines.color = color;
	}

	public function draw() {
		lines.draw(motion.position.x, motion.position.y, rotation, scale);
		lines_points = lines.points();
	}

	public function set_rotation_direction(direction:Int) {
		rotation_direction = direction;
	}

	public function collision_points():Array<Vector> {
		return lines.points();
	}

	public var offset:Float = 0;

	public function collision_center(translation:EditorTranslation):Vector {
		// return motion.position.vector_transform(lines.origin, scale, 0, 0, lines.rotation_sin, lines.rotation_cos);

		var rotation_sin = Math.sin(rotation);
		var rotation_cos = Math.cos(rotation);

		var x_origin = motion.position.x + (lines.origin.x);
		var y_origin = motion.position.y + (lines.origin.y);

		var transformed:Vector = {
			x: x_origin * rotation_cos - y_origin * rotation_sin,
			y: x_origin * rotation_sin + y_origin * rotation_cos
		};

		// scale
		// 		transformed.x = transformed.x * scale;
		// 		transformed.y = transformed.y * scale;
		// 1
		transformed.x = transformed.x + translation.bounds_width_half;
		transformed.y = transformed.y + translation.bounds_height_half;


		transformed.x = transformed.x - (lines.origin.x);
		transformed.y = transformed.y - (lines.origin.y);

		// return {
		// 	x: x_origin,
		// 	y: y_origin
		// }
		return transformed;
		// return {
		// 	x: motion.position.x + scale * (lines.origin.x),
		// 	y: motion.position.y + scale * (lines.origin.y),
		// };
	}

	public function overlaps_polygon(model:Array<Vector>):Bool {
		for (point in model) {
			if (lines_points.polygon_overlaps_point(point)) {
				return true;
			}
		}
		return false;
	}
}
