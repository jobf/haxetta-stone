import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import GraphicsAbstract;
using flixel.util.FlxSpriteUtil;

class Flixel{
	public static function make_polygon(model:Array<Vector>, color:Int):Polygon {
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

	public function new(point_from:Vector, color:Int) {
		super(point_from);
		element = new FlxSprite(
			Std.int(point_from.x), 
			Std.int(point_from.y));
		element.makeGraphic(1, 1);
		element.origin.x = 0;
		element.origin.y = 0;
	}

	function set_color(color:Int){
		color_flixel = FlxColor.WHITE;
		color_abstract = color;
		color_flixel.red = color_abstract.r;
		color_flixel.green = color_abstract.g;
		color_flixel.blue = color_abstract.b;
		color_flixel.alpha = color_abstract.a;
		element.color = color_flixel;
	}

	public function draw(point_to:Vector, color:Int):Void {
		set_color(color);
		a = point_to.x - point_from.x;
		b = point_to.y - point_from.y;
		// // line thickness
		var width = 1;
		// // line length
		var height = Math.sqrt(a * a + b * b);
		element.scale.y = height;

		element.x = point_from.x;
		element.y = point_from.y;
		element.angle = Math.atan2(point_from.x - point_to.x, -(point_from.y - point_to.y)) * (180 / Math.PI);
	}

	var color_abstract:ColorAbstract;
	var color_flixel:FlxColor;
}

class Particle extends AbstractParticle{
	public var element:FlxSprite;

	public function new(x:Int, y:Int, size:Int, color:Int, lifetime_seconds:Float){
		super(x, y, size, color, lifetime_seconds);
		element = new FlxSprite(x, y);
		element.makeGraphic(1, 1, FlxColor.WHITE);
	}
	
	function set_color(color:Int){
		color_flixel = FlxColor.WHITE;
		color_abstract = color;
		color_flixel.red = color_abstract.r;
		color_flixel.green = color_abstract.g;
		color_flixel.blue = color_abstract.b;
		color_flixel.alpha = color_abstract.a;
		element.color = color_flixel;
	}
	public function draw() {
		element.x = motion.position.x;
		element.y = motion.position.y;
		set_color(color);
		element.scale.x = size;
		element.scale.y = size;
		// // element.color = color;
		// element.width = size;
		// element.height = size;
	}

	var color_abstract:ColorAbstract;
	var color_flixel:FlxColor;
}

class Rectangle extends FlxSprite{
	public var rotation(get, set):Float;
	
	function get_rotation():Float {
		return angle;
	}

	function set_rotation(value:Float):Float {
		angle = value;
		return angle;
	}

	public function new(x:Int, y:Int, width:Int, height:Int, color_abstract:ColorAbstract){
		super(x, y);
		color = FlxColor.WHITE;
		color.red = color_abstract.r;
		color.green = color_abstract.g;
		color.blue = color_abstract.b;
		color.alpha = color_abstract.a;
		// makeGraphic(width, height, FlxColor.TRANSPARENT, true);
	}

	public function clear(){

		// if(this.graphic !=null && this.graphic.bitmap != null){
		// 	makeGraphic(Std.int(width), Std.int(height), FlxColor.TRANSPARENT, true);
		// }
	}
}
