import lime.graphics.Image;
import Engine;
import GraphicsAbstract;
import Vector;
import lime.ui.Window;
import peote.view.*;

class Graphics extends GraphicsAbstract {
	var lines:Array<PeoteLine> = [];
	var fills:Array<PeoteFill> = [];
	var window:Window;
	var size_cap:Int = 2;
	var moon_texture:Texture;
	var moon_buffer:Buffer<Sprite>;
	var moon_program:Program;



	public function new(window:Window, viewport_bounds:RectangleGeometry) {
		super(viewport_bounds);
		this.window = window;
		peoteview = new PeoteView(window);
		display = new Display(0, 0, window.width, window.height);
		peoteview.addDisplay(display);

		buffer_fills = new Buffer<Rectangle>(256, 256, true);
		var rectangleProgram = new Program(buffer_fills);
		display.addProgram(rectangleProgram);

		buffer_lines = new Buffer<Line>(256, 256, true);
		var lineProgram = new Program(buffer_lines);
		// lineProgram.setColorFormula( "vec4(base.r, base.g, base.b, base.a * alpha )" );
		display.addProgram(lineProgram);



		peoteview.start();
	}
	
	public function add_moon(image:Image):Sprite{
		moon_texture = new Texture(image.width, image.height);
		moon_texture.setImage(image);
		moon_buffer = new Buffer<Sprite>(1, 1, false);
		moon_program = new Program(moon_buffer);
		display.addProgram(moon_program);
		moon_program.addTexture(moon_texture, "custom");					
		moon_program.snapToPixel(1); // for smooth animation
		var moon = new Sprite(320,320,1015,1015);
		moon_buffer.addElement(moon);
		return moon;
	}

	public function make_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:RGBA):AbstractLine {
		var element = new Line(from_x, from_y, 1, 1, 0, cast color);
		element.timeAStart = 0.0;
		element.timeADuration = 3.0;
		buffer_lines.addElement(element);
		lines.push(new PeoteLine({
			x: from_x,
			y: from_y
		}, {
			x: to_x,
			y: to_y
		},
			element, line -> line_erase(line),
			make_rectangle(Std.int(from_x), Std.int(from_y), size_cap, size_cap, color),
			make_rectangle(Std.int(from_x), Std.int(from_y), size_cap, size_cap, color), cast color));
		// trace('new line $from_x $from_y $to_x $to_y');
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
		buffer_fills.addElement(element);
		return element;
	}

	public function make_particle(x:Float, y:Float, size:Int, color:RGBA, lifetime_seconds:Float):AbstractParticle {
		var element = make_rectangle(x, y, size, size, cast color);
		return new Particle(Std.int(x), Std.int(y), size, cast color, lifetime_seconds, element);
	}

	public function line_erase(line:PeoteLine) {
		buffer_fills.removeElement(line.head);
		buffer_fills.removeElement(line.end);
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
		buffer_fills.update();
		buffer_lines.update();
		moon_buffer.update();
	}

	var peoteview:PeoteView;
	var display:Display;
	var buffer_lines:Buffer<Line>;
	var buffer_fills:Buffer<Rectangle>;

	public function translate_mouse(x:Float, y:Float):Vector {
		return {
			x: display.localX(x),
			y: display.localY(y)
		}
	}

	public function set_color(color:RGBA) {
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
	@color @anim("ColorFade") public var color:Color;
	@posX public var x:Float;
	@posY public var y:Float;
	// pivot x (rotation offset)
	@pivotX public var px:Int = 0;

	// pivot y (rotation offset)
	@pivotY public var py:Int = 0;

	var OPTIONS = {alpha: true};

	// params for blinking alpha
	// @custom("alpha") @varying @anim("A", "pingpong") public var alpha:Float;
	@custom("alpha") @varying @constEnd(1.0) @anim("A", "pingpong") public var alpha:Float;

	public function new(positionX:Float, positionY:Float, width:Float, height:Float, rotation:Float = 0, color:Color = 0x556677ff) {
		this.x = positionX;
		this.y = positionY;
		this.w = width;
		this.h = height;
		this.color = color;
		this.rotation = rotation;
	}

	public function setFlashing(isFlashing:Bool) {
		// todo - adhere to previously set alpha
		if (isFlashing) {
			alphaStart = 0.0;
			// animate Color from red to yellow
			animColorFade(Color.RED, Color.GREEN);
			timeColorFade(0.0, 1.0); // from start-time (0.0) and during 1 seconds
		} else {
			alphaStart = 1.0;
		}
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

	public var head:Rectangle;
	public var end:Rectangle;

	var remove_from_buffer:PeoteLine->Void;

	public var element(default, null):Line;

	public function new(point_from:Vector, point_to:Vector, element:Line, remove_from_buffer:PeoteLine->Void, head:Rectangle, end:Rectangle, color:Color) {
		super(point_from, point_to, cast color);
		this.element = element;
		this.remove_from_buffer = remove_from_buffer;
		this.head = head;
		this.end = end;
		draw();
	}

	public function draw():Void {
		element.color = cast color;

		a = point_to.x - point_from.x;
		b = point_to.y - point_from.y;

		// line thickness
		element.w = 2;

		// line length
		element.h = Math.sqrt(a * a + b * b);

		element.x = point_from.x;
		element.y = point_from.y;
		element.rotation = Math.atan2(point_from.x - point_to.x, -(point_from.y - point_to.y)) * (180 / Math.PI);
		head.x = point_from.x;
		head.y = point_from.y;
		end.x = point_to.x;
		end.y = point_to.y;
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

typedef MakeLine = (from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:RGBA) -> AbstractLine;

class GraphicsToo extends GraphicsAbstract {
	var lines:Array<PeoteLine> = [];
	var fills:Array<PeoteFill> = [];
	var size_cap:Int = 2;
	public function new(peoteview:PeoteView, viewport_bounds:RectangleGeometry) {
		super(viewport_bounds);
		this.peoteview = peoteview;
		display = new Display(0, 0, viewport_bounds.width, viewport_bounds.height);
		peoteview.addDisplay(display);

		buffer_fills = new Buffer<Rectangle>(256, 256, true);
		var rectangleProgram = new Program(buffer_fills);
		rectangleProgram.snapToPixel(1);
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
		}, element, line -> line_erase(line),
		make_rectangle(Std.int(from_x), Std.int(from_y), size_cap,size_cap, color),
		make_rectangle(Std.int(to_x), Std.int(to_y), size_cap,size_cap, color), 
		cast color));
		// trace('new line $from_x $from_y $to_x $to_y');
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
		buffer_fills.addElement(element);
		return element;
	}

	public function make_particle(x:Float, y:Float, size:Int, color:RGBA, lifetime_seconds:Float):AbstractParticle {
		var element = make_rectangle(x, y, size, size, cast color);
		return new Particle(Std.int(x), Std.int(y), size, cast color, lifetime_seconds, element);
	}

	public function line_erase(line:PeoteLine) {
		// trace('remove line too');
		buffer_fills.removeElement(line.head);
		buffer_fills.removeElement(line.end);
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
		buffer_fills.update();
		buffer_lines.update();
	}

	var peoteview:PeoteView;
	var display:Display;
	var buffer_lines:Buffer<Line>;
	var buffer_fills:Buffer<Rectangle>;

	public function translate_mouse(x:Float, y:Float):Vector {
		return {
			x: display.localX(x),
			y: display.localY(y)
		}
	}

	public function set_color(color:RGBA) {
		display.color = cast color;
	}
}

class Sprite implements Element {
	@pivotX @formula("w * 0.5 + px_offset") public var px_offset:Float;
	@pivotY @formula("h * 0.5 + py_offset") public var py_offset:Float;
	@rotation public var rotation:Float;

	@posX public var x:Int=0;
	@posY public var y:Int=0;

	@sizeX public var w:Int;

	@sizeY public var h:Int;

	var OPTIONS = {alpha: true};

	@color public var c:Color;

	public function new(positionX:Int = 0, positionY:Int = 0, width:Int, height:Int, tile:Int = 0, tint:Int = 0xffffffFF, isVisible:Bool = true) {
		this.x = positionX;
		this.y = positionY;
		this.w = width;
		this.h = height;
		c = tint;
	}
}