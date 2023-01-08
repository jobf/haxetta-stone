

import Drawing;
import automation.Oscillator;
import automation.Envelope;


using Vector;
class Performer {
	public var envelope:Envelope;
	public var lfo:LFO;
	public var graphic:Drawing;
	public var jump_height:Float = 1.5;
	public var y_wobble:Float = 0.01;

	var x:Float;
	public var y:Float;
	var oscillate_y:Float;
	public var rotation:Float = 0;
	public var rotation_speed:Float = 1;
	public var scale:Float = 1;



	public function new(graphic:Drawing) {
		this.graphic = graphic;
		this.x = graphic.x;
		this.y = graphic.origin.y;
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
		rotation += 1 * rotation_speed;
		var amp_jump = envelope.nextAmplitude();
		var amp_wobble = lfo.next();
		var jump = -(jump_height * amp_jump);
		var wobble = amp_wobble * y_wobble;
		graphic.scale = scale;
		graphic.rotation = rotation;
		graphic.origin.y = y + jump + wobble;
	}

	public function draw() {
		// graphic.draw();
	}

	public function press() {
		envelope.open();
	}

	public function release() {
		envelope.close();
	}
}
