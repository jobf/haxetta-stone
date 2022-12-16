import Geometry;
import lime.ui.Window;
import peote.view.*;

class Peote {
	static var lines:Array<Rectangle> = [];

	public static function init(window:Window) {
		peoteview = new PeoteView(window);
		display = new Display(0, 0, window.width, window.height);
		peoteview.addDisplay(display);

		lineBuffer = new Buffer<Rectangle>(16);
		var lineProgram = new Program(lineBuffer);
		display.addProgram(lineProgram);
	}

	public static function update(elapsed_seconds:Float) {
		lineBuffer.update();
	}

	public static function make_polygon(model:Array<Point>, color:Color):Polygon {
		return {
			model: model,
			lines: [
				for (point in model)
					{
						point_from: {
							x: point.x,
							y: point.y
						},
						element: {
							var element = new Rectangle();
							lineBuffer.addElement(element);
							element;
						}
					}
			]
		}
	}

	public static function draw_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:Color) {
		var a = to_x - from_x;
		var b = to_y - from_y;
		var lineWidth = 1;
		var lineLength = Math.sqrt(a * a + b * b);
		var lineRotation = Math.atan2(from_x - to_x, -(from_y - to_y)) * (180 / Math.PI);
		lines.push(new Rectangle(from_x, from_y, lineWidth, lineLength, lineRotation, color));
		lineBuffer.addElement(lines[lines.length - 1]);
	}

	public static function draw_polygon(vertices:Array<Point>, color:Color) {
		if (vertices.length < 2) {
			return;
		}

		for (a in 0...vertices.length) {
			var b = a + 1;
			Peote.draw_line(vertices[a % vertices.length].x, vertices[a % vertices.length].y, vertices[b % vertices.length].x,
				vertices[b % vertices.length].y, color);
		}
	}

	public static function clear() {
		var i = lines.length;
		while (i > 0) {
			var element = lines.pop();
			lineBuffer.removeElement(element);
			i--;
		}
	}

	static var peoteview:PeoteView;
	static var display:Display;
	static var lineBuffer:Buffer<Rectangle>;
}

class Rectangle implements Element {
	@pivotX public var px_offset:Float = 0.0;
	@pivotY public var py_offset:Float = 0.0;
	@rotation public var rotation:Float = 0.0;
	@sizeX @varying public var w:Float;
	@sizeY @varying public var h:Float;
	@color public var color:Color;
	@posX public var x:Float;
	@posY public var y:Float;

	var OPTIONS = {alpha: true};

	public function new(positionX:Float = 0, positionY:Float = 0, width:Float = 0, height:Float = 10, rotation:Float = 0, color:Int = 0x556677ff) {
		this.x = positionX;
		this.y = positionY;
		this.w = width;
		this.h = height;
		this.color = color;
		this.rotation = rotation;
	}
}

@:structInit
class Line {
	public var element(default, null):Rectangle;
	public var point_from(default, null):Point;
	var a:Float = 0;
	var b:Float = 0;

	public function draw(point_to:Point) {
		a = point_to.x - point_from.x;
		b = point_to.y - point_from.y;

		element.x = point_from.x;
		element.y = point_from.y;
		element.rotation = Math.atan2(point_from.x - point_to.x, -(point_from.y - point_to.y)) * (180 / Math.PI);

		// line thickness
		element.w = 2;

		// line length
		element.h = Math.sqrt(a * a + b * b);
	}
}

@:structInit
class Polygon {
	var lines:Array<Line>;
	var model:Array<Point>;

	var rotation_sin:Float = 0; 
	var rotation_cos:Float = 0; 

	public function transform(x:Float, y:Float, rotation:Float, scale:Float) {
		rotation_sin = Math.sin(rotation);
		rotation_cos = Math.cos(rotation);

		for (n => line in lines) {
			//rotate
			line.point_from.x = model[n].x * rotation_cos - model[n].y * rotation_sin;
			line.point_from.y = model[n].x * rotation_sin + model[n].y * rotation_cos;

			//scale
			line.point_from.x = line.point_from.x * scale;
			line.point_from.y = line.point_from.y * scale;

			//translate
			line.point_from.x = line.point_from.x + x;
			line.point_from.y = line.point_from.y + y;
		}

		for (a in 0...lines.length) {
			lines[a % lines.length].draw(lines[(a + 1) % lines.length].point_from);
		}
	}
}
