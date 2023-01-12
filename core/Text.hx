import Editor.EditorTranslation;
import Models;
import GraphicsAbstract;

class Text {
	var models:Array<Array<LineModel>>;
	var graphics:GraphicsAbstract;
	var model_translation:EditorTranslation;

	var words:Array<Word> = [];

	public function new(models:Array<Array<LineModel>>, graphics:GraphicsAbstract) {
		if (models.length != 256) {
			throw "character set requires 256 models for code page 437";
		}

		var size_character:Int = 64;

		this.models = models;
		this.graphics = graphics;
		model_translation = new EditorTranslation({
			y: 0,
			x: 0,
			width: size_character,
			height: size_character
		});
	}

	public function draw() {
		for (word in words) {
			word.draw();
		}
	}

	public function word_make(x:Int, y:Int, text:String, color:RGBA, size_character:Int):Word {
		var drawings:Array<Drawing> = [];
		model_translation.size_set(size_character, size_character);
		for (i in 0...text.length) {
			var char_code = text.charCodeAt(i);
			trace('code $char_code letter ${String.fromCharCode(char_code)}');
			drawings.push(drawing_create(models[char_code], x + size_character * i, y, color));
		}

		words.push({
			text: text,
			drawings: drawings
		});

		return words[words.length - 1];
	}

	function drawing_create(model_Lines:Array<LineModel>, x:Float, y:Float, color:RGBA):Drawing {
		return new Drawing({
			model_lines: model_Lines
		}, x, y, graphics.make_line, model_translation, color);
	}
}

@:structInit
class Word {
	var text(default, null):String;
	var drawings(default, null):Array<Drawing>;

	public function erase() {
		for (drawing in drawings) {
			drawing.erase();
		}
	}

	public function draw(){
		for (drawing in drawings) {
			drawing.draw();
		}
	}
}

// class FileParsing {
// 	macro public static function mapLineModelsFrom(file_path:haxe.macro.Expr.ExprOf<String>):ExprOf<Array<Array<LineModel>>> {
// 		var path = switch (file_path.expr) {
// 			case EConst(CString(path)):
// 				path;
// 			default:
// 				throw "type should be string const";
// 		}
// 		var content = CompileTime.readFile(path);
// 		var file:FileModel = try Json.parse(content) catch (e:Dynamic) {
// 			haxe.macro.Context.error('Json from $path failed to validate: $e', Context.currentPos());
// 		}
// 		var line_models = file.models.map(model -> model.lines);
// 		return toExpr(line_models);
// 	}
// 	#if macro
// 	static function toExpr(v:Dynamic) {
// 		return Context.makeExpr(v, Context.currentPos());
// 	}
// 	#end
// }
