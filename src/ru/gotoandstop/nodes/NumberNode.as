package ru.gotoandstop.nodes {
import flash.events.Event;

import ru.gotoandstop.values.NumberValue;

/**
 * @author tmshv
 */
public class NumberNode extends NodeModel {
	private var _value:NumberValue;
	//		public function get value():NumberValue{
	//			return this._value;
	//		}

	public override function get type():String {
		return NodeType.NUMBER;
	}

	public function get number():Number {
		return this._value.value;
	}

	public function set number(value:Number):void {
		this._value.value = value;
	}

	public function NumberNode() {
		super();
		this._value = new NumberValue();
		this._value.name = NodeSystem.getUniqueName();
		//this._value.addEventListener(Event.CHANGE, this.handleChange);
		this._value.addEventListener(Event.CHANGE, super.dispatchEvent);
	}

	public override function setValue(key:String, value:*):void {
		if (key == 'value') {
			this._value.value = value;
		}
	}

	public override function getValue(key:String):* {
		if (key == 'value') {
			return this._value;
		}
		return super.getValue(key);
	}

	private function handleChange(event:Event):void {
	}

	override public function getParams():Vector.<String> {
		var vec:Vector.<String> = new Vector.<String>();
		vec.push('value');
		return vec;
	}
}
}
