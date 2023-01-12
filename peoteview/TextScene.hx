import Engine;
import Text;

class TextScene extends Scene {
	var text:Text;
	var test:Word;

	public function init() {
		var font = font_load_embedded();
		text = new Text(font, game.graphics);
		test = text.word_make(30, 200, "TEST", 0xffffffFF);
	}

	public function update(elapsed_seconds:Float) {}

	public function draw() {
		text.draw();
	}
}
