import GraphicsAbstract;
import Models;
import Editor;
import Asteroid;
using Vector;

class CheeseWheel {
	var cheeses:Array<Shape>;
	var model_translation:EditorTranslation;
	public var rotation_speed:Float = 0.014;

	public var y_origin:Float = 18.5;
	public var scale:Int = 92;
	public var overlap:Float = 5.787;
	public function new() {
		cheeses = [];
	}

	public function create(x, y, model:FigureModel, model_translation:EditorTranslation, graphics:GraphicsAbstract):Shape {
		this.model_translation = model_translation;
		var cheese = new Shape(x, y, graphics, model, model_translation);
		@:privateAccess
		cheese.entity.lines.origin.y = y_origin;
		cheese.entity.scale = scale;
		cheese.entity.set_rotation_direction(-1);
		cheese.entity.rotation_speed = rotation_speed;
		cheeses.push(cheese);
		return cheese;
	}

	public function overlaps(target:Vector):Array<Shape> {
		var matching = cheeses.filter(shape -> target.point_overlaps_circle(shape.entity.collision_center(model_translation), overlap));
		return matching;
	}

	public function overlaps_a_line(target_lines:Array<AbstractLine>):Array<Shape> {
		var collides:(target:AbstractLine, lines:Array<AbstractLine>) -> Bool = (target:AbstractLine, lines:Array<AbstractLine>) -> {
			var collide = false;
			for(l in lines){
				if(VectorLogic.line_overlaps_line(target.point_from, target.point_to, l.point_from, l.point_to)){
					collide = true;
					break;
				}
			}
			return collide;
		}

		for (line in target_lines) {
			var matching = cheeses.filter(shape -> collides(line, shape.entity.lines.lines));
			if(matching.length > 0){
				return matching;
			}
		}

		return [];
	}


	public function remove(cheese:Shape) {
		if (cheeses.contains(cheese)) {
			cheese.entity.lines.erase();
			cheeses.remove(cheese);
		}
	}

	public function update(elapsed_seconds:Float) {
		for (cheese in cheeses) {
			cheese.update(elapsed_seconds);
		}
	}

	public function draw() {
		for (cheese in cheeses) {
			cheese.draw();
		}
	}
}
