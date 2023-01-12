import lime.utils.Assets;
import Engine;
import Text;

class TextScene extends Scene {
	var text:Text;
	var test:Word;

	public function init() {
		var models_json = Assets.getText('assets/code-page-models.json');
		var model_file = Disk.parse_file_contents(models_json);
		var size_model = 64;
		var width_char = 36;
		var font:Font = {
			models: model_file.models.map(model -> model.lines),
			width_model: size_model,
			height_model: size_model,
			width_character: width_char
		}

		text = new Text(font, game.graphics);
		test = text.word_make(30, 200, "TEST", 0xffffffFF);
	}

	public function update(elapsed_seconds:Float) {}

	public function draw() {
		text.draw();
	}
}
