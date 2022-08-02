package core;

import lime.ui.Gamepad;
import input2action.ActionMap;
import lime.ui.Window;
import input2action.Input2Action;
import lime.ui.KeyCode;
import lime.ui.GamepadButton;
import input2action.ActionConfig;

@:structInit
class ActionCallbacks{
	public var onControlLeft:(isDown:Bool)->Void;
	public var onControlRight:(isDown:Bool)->Void;
	public var onControlDown:(isDown:Bool)->Void;
	public var onControlUp:(isDown:Bool)->Void;
	public var onControlAction:(isDown:Bool)->Void;
}

class Controller {
	var actionConfig:ActionConfig;
	var actionMap:ActionMap;
	var input2Action:Input2Action;
	var window:Window;
	var callBacks:ActionCallbacks;

	public function new(window:Window, callBacks:ActionCallbacks) {
		this.window = window;
		this.callBacks = callBacks;
		actionConfig = [
			{
				gamepad: [GamepadButton.DPAD_LEFT, GamepadButton.LEFT_SHOULDER],
				keyboard: KeyCode.LEFT,
				action: "left"
			},
			{
				gamepad: [GamepadButton.DPAD_RIGHT, GamepadButton.RIGHT_SHOULDER],
				keyboard: KeyCode.RIGHT,
				action: "right"
			},
			{
				gamepad: GamepadButton.DPAD_UP,
				keyboard: KeyCode.UP,
				action: "up"
			},
			{
				gamepad: GamepadButton.DPAD_DOWN,
				keyboard: KeyCode.DOWN,
				action: "down"
			},
			{
				gamepad: GamepadButton.B,
				keyboard: KeyCode.LEFT_SHIFT,
				action: "action"
			},
		];

		actionMap = [
			"left" => {
				action: (isDown, playerId) -> {
					callBacks.onControlLeft(isDown);
				},
				up: true
			},
			"right" => {
				action: (isDown, playerId) -> {
					callBacks.onControlRight(isDown);
				},
				up: true
			},
			"up" => {
				action: (isDown, playerId) -> {
					callBacks.onControlUp(isDown);
				},
				up: true
			},
			"down" => {
				action: (isDown, playerId) -> {
					callBacks.onControlDown(isDown);
				},
				up: true
			},
			"action" => {
				action: (isDown, playerId) -> {
					callBacks.onControlAction(isDown);
				},
				up: true
			},
		];

		input2Action = new Input2Action(actionConfig, actionMap);
		input2Action.setKeyboard();

		// event handler for new plugged gamepads
		input2Action.onGamepadConnect = function(gamepad:Gamepad) {
			trace('player gamepad connected');
			input2Action.setGamepad(gamepad);
		}

		input2Action.onGamepadDisconnect = function(player:Int) {
			trace('player $player gamepad disconnected');
		}

	}
	
	public function enable() {
		input2Action.enable(window);
	}

	public function disable() {
		input2Action.disable(window);
	}

}