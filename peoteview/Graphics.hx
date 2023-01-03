import Engine;
import GraphicsAbstract;
import Vector;
import lime.ui.Window;
import peote.view.*;

class Graphics extends GraphicsAbstract {
	var lines:Array<PeoteLine> = [];
	var fills:Array<PeoteFill> = [];

	public function new(window:Window, viewport_bounds:RectangleGeometry) {
		super(viewport_bounds);

		peoteview = new PeoteView(window);
		display = new Display(0, 0, window.width, window.height);
		peoteview.addDisplay(display);

		rectangleBuffer = new Buffer<Rectangle>(256, 256, true);
		var rectangleProgram = new Program(rectangleBuffer);
		display.addProgram(rectangleProgram);

		buffer_lines = new Buffer<Line>(256, 256, true);
		var lineProgram = new Program(buffer_lines);
		display.addProgram(lineProgram);
	}

	public function make_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:RGBA):AbstractLine {
		var element = new Line(from_x, from_y, 1, 1, 0, cast color);
		buffer_lines.addElement(element);
		lines.push(new PeoteLine({
			x: from_x,
			y: from_y
		}, {
			x: to_x,
			y: to_y
		},
		element,
		line -> line_erase(line)));

		return lines[lines.length - 1];
	}

	public function make_fill(x:Int, y:Int, width:Int, height:Int, color:RGBA):AbstractFillRectangle {
		var element = make_rectangle(x, y, width, height, color);
		fills.push(new PeoteFill(element));
		return fills[fills.length - 1];
	}

	function make_rectangle(x:Float, y:Float, width:Float, height:Float, color:RGBA):Rectangle {
		final rotation = 0;
		var element = new Rectangle(x, y, width, height, rotation, cast color);
		rectangleBuffer.addElement(element);
		return element;
	}

	public function make_particle(x:Float, y:Float, size:Int, color:RGBA, lifetime_seconds:Float):AbstractParticle {
		var element = make_rectangle(x, y, size, size, cast color);
		return new Particle(Std.int(x), Std.int(y), size, cast color, lifetime_seconds, element);
	}

	public function line_erase(line:PeoteLine) {
		buffer_lines.removeElement(line.element);
		// trace('removed line from buffer');
		lines.remove(line);
		// trace('removed line from lines array');
	}

	public function draw() {
		for (line in lines) {
			line.draw();
		}
		for (fill in fills) {
			fill.draw();
		}
		rectangleBuffer.update();
		buffer_lines.update();
	}

	var peoteview:PeoteView;
	var display:Display;
	var buffer_lines:Buffer<Line>;
	var rectangleBuffer:Buffer<Rectangle>;

	public function translate_mouse(x:Float, y:Float):Vector {
		return {
			x: display.localX(x),
			y: display.localY(y)
		}
	}

	public function set_color(color:RGBA){
		display.color = cast color;
	}
}

class Rectangle implements Element {
	@pivotX @formula("w * 0.5 + px_offset") public var px_offset:Float;
	@pivotY @formula("h * 0.5 + py_offset") public var py_offset:Float;
	@rotation public var rotation:Float = 0.0;
	@sizeX @varying public var w:Float;
	@sizeY @varying public var h:Float;
	@color public var color:Color;
	@posX public var x:Float;
	@posY public var y:Float;

	var OPTIONS = {alpha: true};

	public function new(positionX:Float, positionY:Float, width:Float, height:Float, rotation:Float = 0, color:Color = 0x556677ff) {
		this.x = positionX;
		this.y = positionY;
		this.w = width;
		this.h = height;
		this.color = color;
		this.rotation = rotation;
	}
}

class Line implements Element {
	@rotation public var rotation:Float = 0.0;
	@sizeX @varying public var w:Float;
	@sizeY @varying public var h:Float;
	@color public var color:Color;
	@posX public var x:Float;
	@posY public var y:Float;

	var OPTIONS = {alpha: true};

	public function new(positionX:Float, positionY:Float, width:Float, height:Float, rotation:Float = 0, color:Color = 0x556677ff) {
		this.x = positionX;
		this.y = positionY;
		this.w = width;
		this.h = height;
		this.color = color;
		this.rotation = rotation;
	}
}

class PeoteFill extends AbstractFillRectangle {
	var element:Rectangle;

	public function new(element:Rectangle) {
		super(element.x, element.y, element.w, element.h, cast element.color);
		this.element = element;
	}

	public function draw() {
		element.x = x;
		element.y = y;
		element.w = width;
		element.h = height;
	}
}

class PeoteLine extends AbstractLine {
	var a:Float = 0;
	var b:Float = 0;
	var remove_from_buffer:PeoteLine->Void;

	public var element(default, null):Line;

	public function new(point_from:Vector, point_to:Vector, element:Line, remove_from_buffer:PeoteLine->Void) {
		super(point_from, point_to, cast element.color);
		this.element = element;
		this.remove_from_buffer = remove_from_buffer;
		draw();
	}

	public function draw():Void {
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

	public function erase():Void {
		remove_from_buffer(this);
	}
}

class Particle extends AbstractParticle {
	var element:Rectangle;

	public function new(x:Int, y:Int, size:Int, color:RGBA, lifetime_seconds:Float, element:Rectangle) {
		super(x, y, size, color, lifetime_seconds);
		this.element = element;
	}

	public function draw() {
		element.x = motion.position.x;
		element.y = motion.position.y;
		element.color = cast color;
		element.w = size;
		element.h = size;
	}
}
