import automation.Envelope;
import Drawing;
import Editor.EditorTranslation;
import graphics.implementation.Graphics;
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
	public var bar_thrust:AbstractFillRectangle;
	var bar_length:Int;
	var bounds:RectangleGeometry;




	public function new(peoteview:PeoteView, bounds:RectangleGeometry, models:Array<FigureModel>, model_translation:EditorTranslation) {
		this.models = models;
		this.peoteview = peoteview;
		this.model_translation = model_translation;
		this.bounds = bounds;

		graphics = new GraphicsToo(peoteview, bounds);
		bar_length = bounds.width - 10;
		var bar_height_thrust = 25;
		var bar_x = Std.int(bounds.width * 0.5);
		var bar_y = bounds.height - 40;
		bar_thrust = graphics.make_fill(bar_x, bar_y, bar_length, bar_height_thrust, 0xff860d6b);
	}

	var message:Array<Drawing> = [];

	public function draw() {
		for (drawing in message) {
			drawing.draw();
		}
		for (drawing in drawings_score) {
			drawing.draw();
		}
		
		for (drawing in drawings_lives) {
			drawing.draw();
		}
		


		graphics.draw();
	}

	final char_size = 64;
	var score:Int = 0;
	var drawings_score:Array<Drawing> = [];
	var drawings_lives:Array<Drawing> = [];
	var score_length = 9;
	public function score_change(difference:Int) {
		score += difference;
		if (drawings_score.length > 0) {
			var s = drawings_score.length;
			while (s-- > 0) {
				score_remove(drawings_score[s]);
			}
		}
		var score_text = StringTools.lpad('$score', "0", score_length);
		var score_length_pixels = char_size * score_length;
		var score_x = (bounds.width * 0.5) - ((score_length_pixels) * 0.5) + (char_size * 0.5);
		for (i in 0...score_text.length) {
			var char_code = score_text.charCodeAt(i);
			var index_char_model = char_code - 48 + 28;
			var x_char = score_x + (i * char_size);
			// trace('score $char_code $x_char');
			drawings_score.push(draw_model(models[index_char_model], x_char, 35));
		}
	}

	public function lives_change(set:Int){
		if (drawings_lives.length > 0) {
			var s = drawings_lives.length;
			while (s-- > 0) {
				remove(drawings_lives, drawings_lives[s]);
			}
		}
		for(i in 0...set){
			var x_char = 420 + (i * (char_size * 1.2));
			var heart = draw_model(models[43], x_char, 560, 0xf253f2FF);
			heart.scale = 1.5;
			drawings_lives.push(heart);
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

	public function remove(drawings:Array<Drawing>, drawing:Drawing) {
		if (drawings.contains(drawing)) {
			for (line in drawing.lines) {
				line.erase();
			}
			drawings.remove(drawing);
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

	public function score_reset() {
		score = 0;
		score_change(0);
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

	function draw_model(model:FigureModel, x:Float, y:Float, color:Int=0xf4f997FF):Drawing {
		return new Drawing({
			figure: model
		}, x, y, graphics.make_line, model_translation, color);
	}


	public function set_thrust_bar(fraction:Float) {
		bar_thrust.width = bar_length * fraction;
	}
}
