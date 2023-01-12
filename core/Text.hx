import Editor.EditorTranslation;
import Models;
import GraphicsAbstract;

@:structInit
class Font {
	public var models:Array<Array<LineModel>>;
	public var width_model:Int;
	public var height_model:Int;
	public var width_character:Int = 0;
}

function font_load_embedded():Font {
	var models_json = CompileTime.readJsonFile("assets/fonts/code-page-models.json");
	// var models_json = Assets.getText('fonts/code-page-models.json');
	var model_file = Disk.parse_file_contents(models_json);
	var size_model = 64;
	var width_char = 36;
	return {
		models: model_file.models.map(model -> model.lines),
		width_model: size_model,
		height_model: size_model,
		width_character: width_char
	}
}

class Text {
	var font:Font;
	var graphics:GraphicsAbstract;
	var model_translation:EditorTranslation;

	var words:Array<Word> = [];

	public function new(font:Font, graphics:GraphicsAbstract) {
		if (font.models.length != 256) {
			throw "character set requires 256 models for code page 437";
		}
		this.font = font;
		this.graphics = graphics;
		model_translation = new EditorTranslation({
			y: 0,
			x: 0,
			width: font.width_model,
			height: font.width_model
		});
	}

	public function draw() {
		for (word in words) {
			word.draw();
		}
	}

	public function word_make(x:Int, y:Int, text:String, color:RGBA):Word {
		var drawings:Array<Drawing> = [];
		for (i in 0...text.length) {
			var char_code = text.charCodeAt(i);
			// trace('code $char_code letter ${String.fromCharCode(char_code)}');
			drawings.push(drawing_create(font.models[char_code], x + font.width_character * i, y, color));
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

	public function draw() {
		for (drawing in drawings) {
			drawing.draw();
		}
	}
}
