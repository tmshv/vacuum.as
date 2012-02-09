package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.*;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.NodeSystem;
import ru.gotoandstop.values.IValue;
import ru.gotoandstop.values.NumberValue;

public class TimeoutObject extends EventDispatcher implements INode {
	private var _name:String;
	public function get name():String {
		return _name;
	}

	public function set name(value:String):void {
		_name = value;
	}

	private var _delay:NumberValue;
	private var _delayObject:NumberValue;
	public var delay:String;

	private var _init:IValue;
	public var init:String;

	private var _cmd:ICommand;

	private var _timeoutID:uint;

	public function TimeoutObject() {
		_cmd = createExecuter();
		_delay = new NumberValue();
	}

	private var _type:String;
	public function get type():String {
		return _type;
	}

	public function set type(value:String):void {
		_type = value;
	}

	public function setKeyValue(key:String, value:*):void {
		if (key == 'delay') {
			if (value is IValue) {
				if (_delayObject) _delayObject.removeEventListener(Event.CHANGE, handleChange);
				_delayObject = value;
				_delayObject.addEventListener(Event.CHANGE, handleChange);
				delay = _delayObject.name;
			} else if (value is Number) {
				_delay.value = value;
			} else {
				if (_delayObject) _delayObject.removeEventListener(Event.CHANGE, handleChange);
				_delayObject = null;
				delay = '';
			}
		} else if (key == 'init') {
			if (_init) _init.removeEventListener(Event.CHANGE, this.handleChange);

			if (value is IValue) {
				_init = value;
				_init.addEventListener(Event.CHANGE, handleChange);
				init = _init.name;
			} else {
				_init = null;
				init = '';
			}
		}
		else {
			//super.setKeyValue(key, value);
		}
	}

	public function update():void {
		clearTimeout(_timeoutID);
		var delay:uint = getDelay();
		_timeoutID = setTimeout(_cmd.execute, delay);
	}

	public function dispose():void {
		if(_delayObject) _delayObject.removeEventListener(Event.CHANGE, handleChange);
		if(_init) _init.removeEventListener(Event.CHANGE, handleChange);
		_cmd = null;
	}

	private function handleChange(event:Event):void {
		update();
	}

	public function getKeyValue(key:String):* {
		if (key == 'delay') {
			return _delay;
		} else if (key == 'init') {
			return _init;
		} else if (key == 'done') {
			return _cmd;
		}
		return null;//super.getKeyValue(key);
	}

	private function createExecuter():ICommand {
		var cmd:ExecuteValue = new ExecuteValue();
		cmd.name = NodeSystem.getUniqueName();
		return cmd;
	}

	public function getParams():Vector.<String> {
		var params:Vector.<String> = new Vector.<String>();
		params.push('init');
		params.push('done');
		params.push('delay');
		return params;
	}

	private function getDelay():Number {
		if (_delayObject) {
			return _delayObject.value;
		} else {
			return _delay.value;
		}
	}
}
}