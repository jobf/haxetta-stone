import Asteroid;
import automation.Envelope;
import automation.Oscillator;

class Actor {
	public var envelope:Envelope;
	public var lfo:LFO;
	public var graphic:Shape;
	public var jump_height:Float = -1.5;
	public var y_wobble:Float = 0.01;

	var x:Float;
	public var y:Float;
	var oscillate_y:Float;

	public function new(graphic:Shape) {
		this.graphic = graphic;
		this.x = graphic.entity.motion.position.x;
		this.y = graphic.entity.lines.origin.y;
		var framesPerSecond = 60;
		envelope = new Envelope(framesPerSecond);
		var wavetable = new WaveTable(framesPerSecond);
		envelope.releaseTime = 0.3;
		lfo = {
			shape: SINE,
			sampleRate: framesPerSecond,
			frequency: 1,
			oscillator: wavetable
		};
		lfo.shape = SINE;
	}

	public function update(elapsed:Float) {
		var amp_jump = envelope.nextAmplitude();
		var amp_wobble = lfo.next();
		var jump = -(jump_height * amp_jump);
		var wobble = amp_wobble * y_wobble;
		graphic.entity.lines.origin.y = y + jump + wobble;
	}

	public function draw() {
		graphic.draw();
	}

	public function press() {
		envelope.open();
	}

	public function release() {
		envelope.close();
	}
}
