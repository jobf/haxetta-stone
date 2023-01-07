
class CountDown {
	var duration:Float;
	var countDown:Float;
	var onComplete:() -> Void;
	var restartWhenComplete:Bool;
	var isReady:Bool = true;

	public function new(durationSeconds:Float, onComplete:Void->Void, restartWhenComplete:Bool = false) {
		this.duration = durationSeconds;
		this.onComplete = onComplete;
		this.restartWhenComplete = restartWhenComplete;
		this.countDown = durationSeconds;
	}

	public function update(elapsedSeconds:Float) {
		countDown -= elapsedSeconds;
		if (isReady && countDown <= 0) {
			isReady = false;
			onComplete();
			if (restartWhenComplete) {
				reset();
			}
		}
	}

	public inline function reset(nextDurationSeconds:Float=0) {
		if(nextDurationSeconds > 0){
			duration = nextDurationSeconds;
		}
		countDown = duration;
		isReady = true;
	}

	public function stop() {
		isReady = false;
	}
}