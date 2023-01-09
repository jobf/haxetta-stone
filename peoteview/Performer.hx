

import GraphicsAbstract;
import Graphics.PeoteLine;
import Graphics.Line;
import Drawing;
import automation.Oscillator;
import automation.Envelope;


using Vector;
class Performer {
	public var amp_jump_env:Envelope;
	public var amp_fall_env:Envelope;
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
		amp_jump_env = new Envelope(framesPerSecond);
		amp_fall_env = new Envelope(framesPerSecond);
		var wavetable = new WaveTable(framesPerSecond);
		amp_jump_env.releaseTime = 0.3;
		amp_fall_env.releaseTime = 2.0;
		amp_fall_env.has_sustain = false;

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
		var amp_jump = amp_jump_env.nextAmplitude() * amp_fall_env.nextAmplitude();
		var amp_wobble = lfo.next();
		var jump = -(jump_height * amp_jump);
		var wobble = amp_wobble * y_wobble;
		graphic.scale = scale;
		graphic.rotation = rotation;
		graphic.origin.y = y + jump + wobble;
	}

	public function set_flashing(is_flashing:Bool){
		var color:RGBA = is_flashing ? 0xBCE19F90 : 0x8A8585FF;
		for (line in graphic.lines) {
			line.color = color;
			var l:PeoteLine = cast line;
			l.head.color = cast color;
			l.end.color = cast color;
			// l.element.setFlashing(is_flashing);
		}
	}

	public function draw() {
		// graphic.draw();
	}

	public function press() {
		amp_jump_env.open();
		amp_fall_env.open();
	}

	public function release() {
		amp_jump_env.close();
		amp_fall_env.close();
	}
}
