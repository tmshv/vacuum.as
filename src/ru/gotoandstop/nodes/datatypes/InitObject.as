/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/8/12
 * Time: 7:30 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.EventDispatcher;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.ExecuteValue;

public class InitObject extends EventDispatcher implements INode{
	private var _cmd:ICommand;
	public function InitObject() {
		_cmd = createExecuter();
	}

	private var _name:String;
	public function get name():String {
		return _name;
	}

	public function set name(value:String):void {
		_name = value;
	}

	private var _type:String;
	public function get type():String {
		return _type;
	}

	public function set type(value:String):void {
		_type = value;
	}

	public function update():void {
		_cmd.execute();
	}

	public function getKeyValue(key:String):* {
		if(key == 'done'){
			return _cmd;
		}
		return this[key];
	}

	public function setKeyValue(key:String, value:*):void {
		if(key != 'done'){
			this[key] = value;
		}
	}

	public function getParams():Vector.<String> {
		var params:Vector.<String> = new Vector.<String>();
		params.push('done');
		return params;
	}

	public function dispose():void {
	}

	private function createExecuter():ICommand {
		var cmd:ExecuteValue = new ExecuteValue();
		return cmd;
	}
}
}
