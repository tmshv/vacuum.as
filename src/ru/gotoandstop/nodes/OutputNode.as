package ru.gotoandstop.nodes {
import flash.events.Event;
import flash.events.IEventDispatcher;

/**
 *
 * creation date: Jan 21, 2012
 * @author Roman Timashev (roman@tmshv.ru)
 **/
public class OutputNode extends NodeModel {
	public var value:IEventDispatcher;

	public override function get type():String {
		return NodeType.OUTPUT;
	}

	public function OutputNode() {
		super();
	}

	public override function setValue(key:String, value:*):void {
		if (key == 'value') {
			trace('output', key, value);
			if (this.value) this.value.removeEventListener(Event.CHANGE, super.dispatchEvent);
			this.value = value;
			if (this.value) this.value.addEventListener(Event.CHANGE, super.dispatchEvent);
			super.dispatchEvent(new Event(Event.CHANGE));
		}
	}

	public override function getValue(key:String):* {
		if (key == 'value') {
			return this.value;
		}
		return super.getValue(key);
	}

	override public function getParams():Vector.<String> {
		var vec:Vector.<String> = new Vector.<String>();
		vec.push('value');
		return vec;
	}
}
}