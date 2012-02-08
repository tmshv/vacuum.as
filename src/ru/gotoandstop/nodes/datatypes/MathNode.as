package ru.gotoandstop.nodes.datatypes {
import ru.gotoandstop.nodes.*;

import flash.events.Event;

import ru.gotoandstop.nodes.core.NodeSystem;

import ru.gotoandstop.values.IValue;
import ru.gotoandstop.values.NumberValue;

/**
 *
 * creation date: Jan 26, 2012
 * @author Roman Timashev (roman@tmshv.ru)
 **/
public class MathNode extends NodeModel {
	private var _value:NumberValue;
	public function get value():NumberValue {
		return this._value;
	}

	public override function get type():String {
		return NodeType.MATH;
	}

	//		public function get number():Number{
	//			return this._value.value;
	//		}
	//		public function set number(value:Number):void{
	//			this._value.value = value;
	//		}

	private var firstValue:NumberValue;
	private var secondValue:NumberValue;

	public var first:String;
	public var second:String;

	public function MathNode() {
		super();
		this._value = new NumberValue();
		this._value.name = NodeSystem.getUniqueName();
	}

	override public function getParams():Vector.<String> {
		var vec:Vector.<String> = new Vector.<String>();
		vec.push('value', 'first', 'second');
		return vec;
	}

	public override function setKeyValue(key:String, value:*):void {
		var v:IValue = value as IValue;
		if (key == 'first') {
			if (this.firstValue) this.firstValue.removeEventListener(Event.CHANGE, this.handleChange);
			if (value is IValue) {
				this.firstValue = value;
				if (this.firstValue) this.firstValue.addEventListener(Event.CHANGE, this.handleChange);
				this.calc();

				this.first = v.name;
			}
		} else if (key == 'second') {
			if (this.secondValue) this.secondValue.removeEventListener(Event.CHANGE, this.handleChange);
			if (value is IValue) {
				this.secondValue = value;
				if (this.secondValue) this.secondValue.addEventListener(Event.CHANGE, this.handleChange);
				this.calc();

				this.second = v.name;
			}
		}
	}

	public override function getKeyValue(key:String):* {
		if (key == 'first') {
			return this.firstValue;
		} else if (key == 'second') {
			return this.secondValue;
		}
		return super.getKeyValue(key);
	}

	private function calc():void {
		var f:Number = this.firstValue ? this.firstValue.value : 0;
		var s:Number = this.secondValue ? this.secondValue.value : 0;
		this._value.value = f + s;
	}

	private function handleChange(event:Event):void {
		this.calc();
	}
}
}