import GraphicsAbstract;
import Vector;

import lime.ui.Window;
import peote.view.*;

class Peote {
	static var lines:Array<Rectangle> = [];

	public static function init(window:Window) {
		peoteview = new PeoteView(window);
		display = new Display(0, 0, window.width, window.height);
		peoteview.addDisplay(display);

		rectangleBuffer = new Buffer<Rectangle>(256, 256, true);
		var rectangleProgram = new Program(rectangleBuffer);
		display.addProgram(rectangleProgram);

		lineBuffer = new Buffer<Rectangle>(16);
		var lineProgram = new Program(lineBuffer);
		display.addProgram(lineProgram);
	}

	public static function draw() {
		rectangleBuffer.update();
		lineBuffer.update();
	}

	static function make_line(x:Float, y:Float, color:Int):AbstractLine {
		var element = new Rectangle();
		lineBuffer.addElement(element);
		var line:Line = new Line({
			x: x,
			y: y
		}, color);

		return line;
	}

	public static function make_polygon(model:Array<Vector>, color:Color):Polygon {
		return {
			model: model,
			color: cast color,
			lines: [ for (point in model) make_line(point.x, point.y, color)]
		}
	}

	static var peoteview:PeoteView;
	static var display:Display;
	static var lineBuffer:Buffer<Rectangle>;
	static var rectangleBuffer:Buffer<Rectangle>;

	public static function make_rectangle(x:Float, y:Float, width:Float, height:Float, color:Color):Rectangle {
		var rectangle = new Rectangle(x, y, width, height, 0, color);
		rectangleBuffer.addElement(rectangle);
		return rectangle;
	}

	public static function make_particle(x:Float, y:Float, color:Int, size:Int, lifetime_seconds:Float):AbstractParticle {
		return new Particle(Std.int(x), Std.int(y),size, color, lifetime_seconds);
	}
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

class Line extends AbstractLine {
	var a:Float = 0;
	var b:Float = 0;
	var element:Rectangle;

	public function new(point_from:Vector, color:RGBA) {
		super(point_from);
		element = Peote.make_rectangle(point_from.x, point_from.y, 0, 0, cast color);
	}

	public function draw(point_to:Vector, color:RGBA):Void {
		
		element.color = cast color;
		
		a = point_to.x - point_from.x;
		b = point_to.y - point_from.y;

		element.x = point_from.x;
		element.y = point_from.y;
		element.rotation = Math.atan2(point_from.x - point_to.x, -(point_from.y - point_to.y)) * (180 / Math.PI);

		// line thickness
		element.w = 1;

		// line length
		element.h = Math.sqrt(a * a + b * b);
	}
}

class Particle extends AbstractParticle{
	var element:Rectangle;

	public function new(x:Int, y:Int, size:Int, color:RGBA, lifetime_seconds:Float){
		super(x, y, size, color, lifetime_seconds);
		element = Peote.make_rectangle(x, y, size, size, cast color);
	}

	public function draw() {
		element.x = motion.position.x;
		element.y = motion.position.y;
		element.color = cast color;
		element.w = size;
		element.h = size;

		// trace('${ motion.position.x}');
	}
}
