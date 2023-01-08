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
		graphics.draw();
	}

	public function write_message(text:String) {
		final char_size = 56;
		final index_model_offset = 1;
		for (i in 0...text.length) {
			var char_code = text.charCodeAt(i);
			var is_number = char_code >= 48 && char_code <= 57;
			var index_char_offset = is_number ? 48 : 65;
			var index_char_model = char_code - index_char_offset + index_model_offset;
			if (is_number) {
				index_char_model += 27;
			}
			else{
				if(char_code == 32){
					index_char_model = 27;
				}
			}
			trace('${String.fromCharCode(char_code)} code $char_code model_index $index_char_model');
			message.push(draw_model(models[index_char_model], 16 + (i * char_size), 35));
		}
	}

	function draw_model(model:FigureModel, x:Float, y:Float):Drawing {
		return new Drawing({
			figure: model
		}, x, y, graphics.make_line, model_translation);
	}
}
