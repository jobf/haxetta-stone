import openfl.net.FileFilter;
import flixel.input.FlxInput;
import Engine;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import GraphicsAbstract;

using flixel.util.FlxSpriteUtil;

class Graphics extends GraphicsAbstract {
	var elements:FlxGroup;
	var lines:FlxTypedGroup<FlxLine>;
	var fills:Array<Fill>;

	public function new(elements:FlxGroup, viewport_bounds:RectangleGeometry) {
		super(viewport_bounds);
		this.elements = elements;
		lines = new FlxTypedGroup<FlxLine>();
		elements.add(lines);
		fills = [];
	}

	public function draw() {
		for (line in lines) {
			line.draw();
		}
		for (fill in fills) {
			fill.draw();
		}
	}

	public function make_line(from_x:Float, from_y:Float, to_x:Float, to_y:Float, color:RGBA):AbstractLine {
		var line = new Line({
			x: from_x,
			y: from_y
		}, {
			x: to_x,
			y: to_y
		}, color);

		elements.add(line.element);
		return line;
	}

	public function make_particle(x:Float, y:Float, size:Int, color:RGBA, lifetime_seconds:Float):AbstractParticle {
		var particle = new Particle(Std.int(x), Std.int(y), size, color, lifetime_seconds);

		elements.add(particle.element);
		return particle;
	}

	public function make_fill(x:Int, y:Int, width:Int, height:Int, color:RGBA):AbstractFillRectangle {
		var fill = new Fill(x, y, width, height, color);
		fills.push(fill);
		elements.add(fill.element);
		return fill;
	}
}

class Line extends AbstractLine {
	public var element(default, null):FlxLine;

	public function new(point_from:Vector, point_to:Vector, color:RGBA) {
		super(point_from, point_to, color);
		element = new FlxLine(point_from, point_to, color);
	}

	public function draw():Void {
		// flixel line need to sync with abstract line
		element.point_from = point_from;
		element.point_to = point_to;

		// update color
		element.color_abstract = color;

		// element.draw will be called from flixel draw loop
		// ? - todo rename abstract 'draw' to 'sync' to not confuse with element.draw??
	}
}

class Fill extends AbstractFillRectangle {
	public var element(default, null):FlxFill;

	public function new(x:Int, y:Int, width:Int, height:Int, color:RGBA) {
		super(x, y, width, height, color);
		element = new FlxFill(x, y, width, height, color);
	}

	public function draw():Void {
		element.x = x;
		element.y  = y;
		element.scale.x = width;
		element.scale.y = height;
		element.color = cast_color(color);
	}
}

class Particle extends AbstractParticle {
	public var element:FlxSprite;

	var color_flixel:FlxColor;

	public function new(x:Int, y:Int, size:Int, color:RGBA, lifetime_seconds:Float) {
		super(x, y, size, color, lifetime_seconds);
		element = new FlxSprite(x, y);
		element.makeGraphic(1, 1, FlxColor.WHITE, true);
		set_element_color(element, color);
	}

	public function draw() {
		// update color
		set_element_color(element, color);

		// update position
		element.x = motion.position.x;
		element.y = motion.position.y;

		// update size
		element.scale.x = size;
		element.scale.y = size;

		element.centerOrigin();
	}
}

function cast_color(color:RGBA):FlxColor {
	var color_flixel = FlxColor.WHITE;
	color_flixel.red = color.r;
	color_flixel.green = color.g;
	color_flixel.blue = color.b;
	color_flixel.alpha = color.a;
	return color_flixel;
}

function set_element_color(element:FlxSprite, color:RGBA) {
	var color_flixel = FlxColor.WHITE;
	color_flixel.red = color.r;
	color_flixel.green = color.g;
	color_flixel.blue = color.b;
	element.color = color_flixel;
	color_flixel.alpha = color.a;
	element.alpha = color_flixel.alphaFloat;
}

class FlxFill extends FlxSprite {
	var color_abstract:RGBA;

	public function new(x:Int, y:Int, width:Int, height:Int, color:RGBA) {
		super(x, y);
		makeGraphic(1, 1, FlxColor.WHITE);
		color_abstract = color;
		this.color = cast_color(color_abstract);
	}
}

class FlxLine extends FlxSprite {
	public var point_from:Vector;
	public var point_to:Vector;
	public var color_abstract:RGBA;

	var a:Float;
	var b:Float;

	public function new(from:Vector, to:Vector, color:RGBA) {
		super(from.x, from.y);
		this.point_from = from;
		this.point_to = to;
		makeGraphic(1, 1, FlxColor.WHITE);
		origin.x = 0;
		origin.y = 0;
		color_abstract = color;
		this.color = cast_color(color_abstract);
	}

	public override function draw() {
		// update color
		this.color = cast_color(color_abstract);

		a = point_to.x - point_from.x;
		b = point_to.y - point_from.y;

		// line length
		scale.y = Math.sqrt(a * a + b * b);

		// line start position
		x = point_from.x;
		y = point_from.y;

		// line rotation
		angle = Math.atan2(point_from.x - point_to.x, -(point_from.y - point_to.y)) * (180 / Math.PI);

		// continue flixel draw call
		super.draw();
	}
}
