/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 03.02.12
 * Time: 3:52
 *
 */
package ru.gotoandstop.nodes.core {
import flash.events.Event;

import ru.gotoandstop.nodes.core.NodeEvent;

public class NodeEvent extends Event{
	private var _key:String;
	public function get key():String {
		return _key;
	}
	
	private var _value:*;
	public function get value():* {
		return _value;
	}

	public function NodeEvent(key:String, value:*) {
		super(Event.CHANGE, false, false);
		_key = key;
		_value = value;
	}

	override public function clone():Event {
		return new NodeEvent(key,  value);
	}

	override public function toString():String {
		var msg:String = '{node name key value}';
		msg = msg.replace('name', super.target);
		msg = msg.replace('key', key);
		msg = msg.replace('value', value);
		return msg;
	}
}
}
