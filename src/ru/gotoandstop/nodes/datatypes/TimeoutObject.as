package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.*;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.NodeSystem;
import ru.gotoandstop.nodes.datatypes.ActionObject;
import ru.gotoandstop.values.IValue;
import ru.gotoandstop.values.NumberValue;

public class TimeoutObject extends ActionObject{
	private var _delay:NumberValue;
	private var _delayObject:NumberValue;
	public var delay:String;

	private var _timeoutID:uint;

	public function TimeoutObject() {
		_delay = new NumberValue();
	}

	override public function set(key:String, value:*):void {
		if (key == 'delay') {
			if (value is IValue) {
				if (_delayObject) _delayObject.removeEventListener(Event.CHANGE, handleChange);
				_delayObject = value;
				_delayObject.addEventListener(Event.CHANGE, handleChange);
				delay = _delayObject.id;
			} else if (value is Number) {
				_delay.value = value;
			} else {
				if (_delayObject) _delayObject.removeEventListener(Event.CHANGE, handleChange);
				_delayObject = null;
				delay = '';
			}
		}else {
			super.set(key, value);
		}
	}

	override public function update():void {
		clearTimeout(_timeoutID);
		var delay:uint = getDelay();
//		_timeoutID = setTimeout(super._done.execute, delay);
	}

	override public function dispose():void {
		if(_delayObject) _delayObject.removeEventListener(Event.CHANGE, handleChange);
        super.dispose();
	}

    private function handleChange(event:Event):void {
        update();
    }

    override protected function executeAction():void {
        update();
    }

    override public function get(key:String):* {
		if (key == 'delay') {
			return _delay;
		}
		return super.get(key);
	}

	override public function getParams():Vector.<String> {
		var params:Vector.<String> = super.getParams();
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