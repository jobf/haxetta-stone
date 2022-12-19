import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import GraphicsAbstract;
using flixel.util.FlxSpriteUtil;

class Flixel{
	public static function make_polygon(model:Array<Vector>, color:RGBA):Polygon {
		return {
			model: model,
			color: color,
			lines: [ for (point in model) {
				var line = new Line(point, color);
				sprites.add(line.element);
				line;
			}]
		}
	}

	public static function make_particle(x:Float, y:Float, color:Int, size:Int, lifetime_seconds:Float):AbstractParticle {
		var particle = new Particle(Std.int(x), Std.int(y), size, color, lifetime_seconds);
		sprites.add(particle.element);
		return particle;
	}

	public static function init(state:FlxGroup) {
		sprites = state;
	}

	static var sprites:FlxGroup;
}

class Line extends AbstractLine {
	var a:Float = 0;
	var b:Float = 0;
	public var element(default, null):FlxSprite;

	public function new(point_from:Vector, color:RGBA) {
		super(point_from);
		element = new FlxSprite(
			Std.int(point_from.x), 
			Std.int(point_from.y));
		element.makeGraphic(1, 1);
		element.origin.x = 0;
		element.origin.y = 0;
	}

	public function draw(point_to:Vector, color:RGBA):Void {
		//update color 
		set_color(element, color);

		a = point_to.x - point_from.x;
		b = point_to.y - point_from.y;
		
		// line length
		element.scale.y = Math.sqrt(a * a + b * b);

		// line start position
		element.x = point_from.x;
		element.y = point_from.y;

		// line rotation
		element.angle = Math.atan2(point_from.x - point_to.x, -(point_from.y - point_to.y)) * (180 / Math.PI);
	}

	var color_abstract:RGBA;
	var color_flixel:FlxColor;
}

class Particle extends AbstractParticle{
	public var element:FlxSprite;
	var color_flixel:FlxColor;

	public function new(x:Int, y:Int, size:Int, color:RGBA, lifetime_seconds:Float){
		super(x, y, size, color, lifetime_seconds);
		element = new FlxSprite(x, y);
		element.makeGraphic(1, 1, FlxColor.WHITE);
	}

	public function draw() {
		//update color 
		set_color(element, color);
		
		// update position
		element.x = motion.position.x;
		element.y = motion.position.y;
		
		// update size
		element.scale.x = size;
		element.scale.y = size;
	}
}

function set_color(element:FlxSprite, color:RGBA){
	var color_flixel = FlxColor.WHITE;
	color_flixel.red = color.r;
	color_flixel.green = color.g;
	color_flixel.blue = color.b;
	color_flixel.alpha = color.a;
	element.color = color_flixel;
}