

function randomInt(min:Int, max:Int) {
	return Math.floor((max - min )* Math.random()) + min;
}

function randomFloat(min:Float = 0, max:Float = 1):Float {
	return min + Math.random() * (max - min);
}

function randomChance(percent:Float = 50):Bool{
	return Math.random() < percent / 100;
}

