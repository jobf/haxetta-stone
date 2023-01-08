import Editor;
import GraphicsAbstract;
import Models;
import Drawing;

using Vector;

class Wheel {
	var drawings:Array<Drawing>;
	var model_translation:EditorTranslation;
	public var rotation_speed:Float = 0.018;
	public var rotation_init:Float = 180;
	// public var rotation_direction:Int = -1;
	public var y_origin:Float = -2;
	public var scale:Float = 1;
	public var overlap:Float = 5;
	var x:Float;
	var y:Float;
	var color:Int;



	public function new(color:Int) {
		drawings = [];
		this.color = color;
	}

	public function create(x, y, model:FigureModel, model_translation:EditorTranslation, graphics:GraphicsAbstract):Drawing {
		// trace('new drawin');
		this.x = x;
		this.y = y;
		this.model_translation = model_translation;
		var drawing = new Drawing({
			figure: model,
		}, x, y, graphics.make_line, model_translation, color);
		// drawing.rotation
		@:privateAccess
		drawing.origin.y = y_origin;
		drawing.scale = scale;
		drawing.rotation = rotation_init;
		drawing.rotation_speed = rotation_speed;
		drawing.rotation_direction = -1;
		drawings.push(drawing);
		return drawing;
	}

	public function overlaps(target:Vector):Array<Drawing> {
		var matching = drawings.filter(shape -> target.point_overlaps_circle({
			y: shape.y,
			x: shape.x
		}, overlap));
		return matching;
	}

	public function overlaps_a_line(target_lines:Array<AbstractLine>):Array<Drawing> {
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
			var matching = drawings.filter(shape -> collides(line, shape.lines));
			if(matching.length > 0){
				return matching;
			}
		}

		return [];
	}


	public function remove(drawing:Drawing) {
		if (drawings.contains(drawing)) {
			for (line in drawing.lines) {
				line.erase();
			}
			drawings.remove(drawing);
		}
	}

	public function update(elapsed_seconds:Float) {

		// rotation = rotation + (rotation_speed * rotation_direction);
		for (drawing in drawings) {
			// drawing.x = x;
			// drawing.y = y;
			drawing.origin.y = y_origin;
			// drawing.rotation = rotation;
			// drawing.rotation_speed = rotation_speed;
			drawing.scale = scale;
			drawing.draw();
		}
	}

	public function draw() {
		// for (drawing in drawings) {
		// 	drawing.draw();
		// }
	}
}