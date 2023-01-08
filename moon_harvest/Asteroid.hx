import Editor;
import Models;
import GraphicsAbstract;

using Vector;

class Asteroid {
	public var motion(default, null):MotionComponent;
	public var entity:Entity;
	var weight:Float = 250;
	var scale = 6;

	public function new(x:Int, y:Int, graphics:GraphicsAbstract) {
		
		// set up shape model
		var model = new AsteroidModel(x, y, 7, 6, 8);
		var white:Int = 0xFF00FFff;
		entity = new Entity(model.points, x, y, 0.005, graphics);
		entity.set_rotation_direction(Math.random() > 0.5 ? -1 : 1);
		entity.lines.origin.y;
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


class Shape {
	// public var motion(default, null):MotionComponent;
	public var entity:Entity;
	public var center:AbstractFillRectangle;
	var weight:Float = 250;
	var scale = 60;
	var translation:EditorTranslation;
	public var is_active:Bool = true;

	public function new(x:Int, y:Int, graphics:GraphicsAbstract, figureModel:FigureModel, translation:EditorTranslation) {
		this.translation = translation;
		
		// set up shape model
		var map:LineModel->Vector =model -> return {
			y: model.from.y,
			x: model.from.x
		}
		// var from = translation.model_to_view_point(line.from);
		// var to = translation.model_to_view_point(line.to);
		

		var model:Array<Vector> = figureModel.lines.map(model -> translation.model_to_view_point(map(model)));
		for (_line_point_from in model) {
			trace('translated line ${_line_point_from.x},${_line_point_from.y}');
		}
		var white:Int = 0xFF00FFff;
		entity = new Entity(model, x, y, 0.05, graphics);
		center = graphics.make_fill(x, y, 30, 30, 0xFF4444ff);

		// entity.set_rotation_direction(Math.random() > 0.5 ? -1 : 1);
		// entity.lines.origin.y;
	}

	public function update(elapsed_seconds:Float) {
		if(!is_active){
			return;
		}

		entity.update(elapsed_seconds);
		// var center_model = translation.view_to_model_point(entity.collision_center(translation));

		var center_ent = entity.collision_center(translation);
		center.x = center_ent.x;
		center.y = center_ent.y;
	}


	public function draw() {
		entity.draw();
	}

	public function overlaps_polygon(model:Array<Vector>):Bool {
		return entity.overlaps_polygon(model);
	}
}
