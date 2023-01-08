import LunarScene.Drawing;
import Editor.EditorTranslation;
import Graphics;
import Models;
import lime.ui.Window;
import peote.view.*;
import Engine;
import GraphicsAbstract;
import Vector;

class Hud {
	var peoteview:PeoteView;
	var models:Array<FigureModel>;
	var model_translation:EditorTranslation;
	var graphics:GraphicsToo;

	public function new(peoteview:PeoteView, bounds:RectangleGeometry, models:Array<FigureModel>, model_translation:EditorTranslation) {
		this.models = models;
		this.peoteview = peoteview;
		this.model_translation = model_translation;

		graphics = new GraphicsToo(peoteview, bounds);
	}

	var message:Array<Drawing> = [];

	public function draw() {
		for (drawing in message) {
			drawing.draw();
		}
		for (drawing in drawings_score) {
			drawing.draw();
		}
		graphics.draw();
	}

	final char_size = 56;
	var score:Int = 0;
	var drawings_score:Array<Drawing> = [];

	public function score_change(difference:Int) {
		score += difference;
		if (drawings_score.length > 0) {
			var s = drawings_score.length;
			while (s-- > 0) {
				score_remove(drawings_score[s]);
			}
		}
		var score_text = StringTools.lpad('$score', "0", 9);
		for (i in 0...score_text.length) {
			var char_code = score_text.charCodeAt(i);
			var index_char_model = char_code - 48 + 28;
			var x_char = 16 + (i * char_size);
			// trace('score $char_code $x_char');
			drawings_score.push(draw_model(models[index_char_model], x_char, 35));
		}
	}

	public function message_remove(drawing:Drawing) {
		if (message.contains(drawing)) {
			for (line in drawing.lines) {
				line.erase();
			}
			message.remove(drawing);
		}
	}

	public function score_remove(drawing:Drawing) {
		if (drawings_score.contains(drawing)) {
			for (line in drawing.lines) {
				line.erase();
			}
			drawings_score.remove(drawing);
		}
	}

	public function write_message(text:String) {
		final index_model_offset = 1;
		for (i in 0...text.length) {
			var char_code = text.charCodeAt(i);
			var is_number = char_code >= 48 && char_code <= 57;
			var index_char_offset = is_number ? 48 : 65;
			var index_char_model = char_code - index_char_offset + index_model_offset;
			if (is_number) {
				index_char_model += 27;
			} else {
				if (char_code == 32) {
					index_char_model = 27;
				}
			}
			trace('${String.fromCharCode(char_code)} code $char_code model_index $index_char_model');
			message.push(draw_model(models[index_char_model], 16 + (i * char_size), 70));
		}
	}

	function draw_model(model:FigureModel, x:Float, y:Float):Drawing {
		return new Drawing({
			figure: model
		}, x, y, graphics.make_line, model_translation);
	}
}