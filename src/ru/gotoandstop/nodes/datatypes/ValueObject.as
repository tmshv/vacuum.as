package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;
import flash.events.EventDispatcher;

import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.INodeSystem;

import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.values.IValue;

/**
 * @author tmshv
 */
public class ValueObject extends EventDispatcher implements INode, IValue {
	private var _value:IValue;

	private var _type:String;
	public function get type():String {
		return _type;
	}

	public function set type(value:String):void {
		_type = value;
	}

	private var _name:String;

	public function get name():String {
		return _name;
	}
	public function set name(value:String):void {
		_name = value;
		_value.name = value;
	}

    private var _system:INodeSystem;
    public function get system():INodeSystem {
        return _system;
    }
    public function set system(value:INodeSystem):void{
        _system = value;
    }

	public function ValueObject(value:IValue) {
		super();
		_value = value;
		_value.addEventListener(Event.CHANGE, handleChange);
	}

	public function dispose():void {
		_value.removeEventListener(Event.CHANGE, handleChange);
		_value = null;
	}

	public function update():void {
		super.dispatchEvent(new NodeChangeEvent('value', _value.getValue()));
	}

	public function setKeyValue(key:String, value:*):void {
		if (key == 'value') {
			_value.setValue(value);
		}
	}

	public function getKeyValue(key:String):* {
		if (key == 'value') {
			return _value;
		}
		return null;
	}

	public function getParams():Vector.<String> {
		var vec:Vector.<String> = new Vector.<String>();
		vec.push('value');
		return vec;
	}

	public function getValue():* {
		return _value.getValue();
	}

	public function setValue(value:*):void {
        if(_value) {
            _value.setValue(value);
        }
	}

	private function handleChange(event:Event):void {
		update();
	}
}
}
