/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/7/12
 * Time: 5:06 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;
import flash.events.EventDispatcher;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.values.IValue;

public class CommandObject extends EventDispatcher implements INode {
	private var _name:String;
	public function get name():String {
		return _name;
	}

	public function set name(value:String):void {
		_name = value;
	}

	private var _init:IValue;

	public function dispose():void {
	}

	public var init:String;

	public var command:ICommand;
	public var description:String;

	public function CommandObject() {

	}

	private var _type:String;
	public function get type():String {
		return _type;
	}

	public function set type(value:String):void {
		_type = value;
	}

	public function setKeyValue(key:String, value:*):void {
		if (key == 'init') {
			if (this._init) this._init.removeEventListener(Event.CHANGE, this.handleChange);

			if (value is IValue) {
				this._init = value;
				this._init.addEventListener(Event.CHANGE, this.handleChange);
				this.init = this._init.name;
			} else {
				this._init = null;
				this.init = '';
			}
		} else {
			this[key] = value;
		}
	}

	private function handleChange(event:Event):void {
		if (command) {
			command.execute();
		}
	}

	public function getKeyValue(key:String):* {
		if (key == 'init') {
			return _init;
		} else {
			return this[key];
		}
	}

	public function getParams():Vector.<String> {
		var params:Vector.<String> = new Vector.<String>();
		params.push('init');
		params.push('description');
		return params;
	}

	public function update():void {
	}
}
}
