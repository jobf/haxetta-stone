import lime.utils.Assets;
import Engine;
import Text;

class TextScene extends Scene {
	var text:Text;
	var test:Word;

	public function init() {
		var models_json = Assets.getText('assets/code-page-models.json');
		var model_file = Disk.parse_file_contents(models_json);
		var models = model_file.models.map(model -> model.lines);
		text = new Text(models, game.graphics);
		var size_character = 64;
		test = text.word_make(size_character, size_character, "TEST", 0xffffffFF, size_character);
	}

	public function update(elapsed_seconds:Float) {}

	public function draw() {
		text.draw();
	}
}
