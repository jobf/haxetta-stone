import Editor;
import GraphicsAbstract;
import Graphics;
import Models;

using Vector;

@:structInit
class Prototype{
	public var figure:FigureModel;
}

class Drawing{
	var model:Prototype;
	var model_translation:EditorTranslation;
	public var origin:Vector = {
		x:-0.5,
		y:-0.5
	};
	public var x:Float = 0;
	public var y:Float = 0;
	public var scale:Float = 1;
	public var rotation:Float = 0;
	public var rotation_speed:Float = -0.01;
	public var rotation_direction:Int = 0;


	public var lines:Array<AbstractLine> = [];
	public function new(model:Prototype, x:Float, y:Float, make_line:MakeLine, model_translation:EditorTranslation, color:Int = 0x2C8D49ff) {
		this.x = x;
		this.y = y;
		this.model = model;
		this.model_translation = model_translation;
		for (proto in model.figure.lines) {
			var line =  make_line(0,0,1,1, color);
			lines.push(line);
		}
	}

	function translate(line_proto:LineModel, line_drawing:AbstractLine, rotation_sin:Float, rotation_cos:Float){
		var from_:Vector ={
			x: line_proto.from.x + origin.x,
			y: line_proto.from.y + origin.y
		}
		var to_:Vector = {
			x: line_proto.to.x + origin.x,
			y: line_proto.to.y + origin.y
		}
		var from = model_translation.model_to_view_point(from_).vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
		var to = model_translation.model_to_view_point(to_).vector_transform(origin, scale, x, y, rotation_sin, rotation_cos);
		line_drawing.point_from.x = from.x - (origin.y * scale);
		line_drawing.point_from.y = from.y - (origin.y * scale);
		line_drawing.point_to.x = to.x - (origin.x * scale);
		line_drawing.point_to.y = to.y - (origin.y * scale);
	}

	public function draw(){
		rotation = rotation + (rotation_speed * rotation_direction);

		var rotation_sin = Math.sin(rotation);
		var rotation_cos = Math.cos(rotation);
		for (n => proto in model.figure.lines) {
			translate(proto, lines[n], rotation_sin, rotation_cos);
		}
	}
}

