import InputAbstract;

@:structInit
class Action {
	public var on_pressed:Void->Void = () -> return;
	public var on_released:Void->Void = () -> return;
}

@:structInit
class ControllerActions {
	public var left:Action = {};
	public var right:Action = {};
	public var up:Action = {};
	public var down:Action = {};
}

class Controller {
	var actions:ControllerActions;
	var input:InputAbstract;

	public function new(actions:ControllerActions, input:InputAbstract) {
		this.actions = actions;
		this.input = input;
	}

	function handle_button(state:ButtonState, action:Action){
		switch state {
			case PRESSED: action.on_pressed();
			case RELEASED: action.on_released();
			case NONE:
		}
	}

	public function update() {
		handle_button(input.get_button_state(KEY_LEFT), actions.left);
		handle_button(input.get_button_state(KEY_RIGHT), actions.right);
		handle_button(input.get_button_state(KEY_UP), actions.up);
		handle_button(input.get_button_state(KEY_DOWN), actions.down);
	}
}
