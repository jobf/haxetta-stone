import InputAbstract;

@:structInit
class Action {
	public var on_pressed:Void->Void = () -> return;
	public var on_released:Void->Void = () -> return;
	public var name:String = "";
}

@:structInit
class ControllerActions {
	public var left:Action = {};
	public var right:Action = {};
	public var up:Action = {};
	public var down:Action = {};
}

class Controller {
	var actions:Map<Button, Action>;
	var input:InputAbstract;

	public function new(actions:Map<Button, Action>, input:InputAbstract) {
		this.actions = actions;
		this.input = input;
	}

	public function handle_button(state:ButtonState, button:Button) {
		switch state {
			case PRESSED:
				{
					if (actions.exists(button)) {
						actions[button].on_pressed();
					}
				}
			case RELEASED:
				{
					if (actions.exists(button)) {
						actions[button].on_released();
					}
				};
			case NONE:
		}
	}
}
