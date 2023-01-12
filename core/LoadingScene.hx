import lime.utils.Preloader;
import GraphicsAbstract;
import Engine;
import Text;

class LoadingScene extends Scene {
	var text:Text;
	var test:Word;
	var preloader:Preloader;

	public function new(preloader:Preloader, scene_constructor:Game->Scene, game:Game, bounds:RectangleGeometry, color:RGBA) {
		super(game, bounds, color);
		this.preloader = preloader;
		preloader.onProgress.add((loaded, total) -> trace('loaded $loaded, total $total'));
		preloader.onComplete.add(() -> game.scene_change(scene_constructor));
	}

	public function init() {
		var font = font_load_embedded();
		text = new Text(font, game.graphics);
		test = text.word_make(30, 200, "LOADING . . .", 0xffffffFF);
	}

	public function update(elapsed_seconds:Float) {}

	public function draw() {
		text.draw();
	}

	public function close() {
	}
}
