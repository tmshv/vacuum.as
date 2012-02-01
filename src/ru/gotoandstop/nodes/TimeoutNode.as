/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/1/12
 * Time: 5:31 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes {
import flash.events.Event;
import flash.text.engine.EastAsianJustifier;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.values.IValue;
import ru.gotoandstop.values.IntValue;
import ru.gotoandstop.values.NumberValue;

public class TimeoutNode extends NodeModel{
	private var _delay:NumberValue;
	public var delay:String;
	
	private var _init:ExecuteValue;
	public var init:String;
	
	private var _cmd:ICommand;
	private var _timeoutID:uint;
	
	public function TimeoutNode() {
		_cmd = createExecuter();
	}

	override public function get type():String {
		return 'timeout';
	}

	public override function setValue(key:String, value:*):void{
		if(key == 'delay'){
			if(this._delay) this._delay.removeEventListener(Event.CHANGE, this.handleChange);

			if(value is IValue){
				this._delay = value;
				this.delay = this._delay.name;
			}else{
				this._delay = null;
				this.delay = '';
			}
		}else if(key == 'init'){
			if(this._init) this._init.removeEventListener(Event.CHANGE, this.handleChange);

			if(value is IValue){
				this._init = value;
				this._init.addEventListener(Event.CHANGE, this.handleChange);
				this.init = this._init.name;
				this.handleChange(null);
			}else{
				this._init = null;
				this.init = '';
			}
		}
		else{
			super.setValue(key, value);
		}
	}

	private function handleChange(event:Event):void{
		clearTimeout(_timeoutID);
		var delay:uint = _delay ? _delay.value : 0;
		_timeoutID = setTimeout(_cmd.execute, delay);
	}

	public override function getValue(key:String):*{
		if(key == 'delay'){
			return _delay;
		}else if(key == 'init'){
			return _init;
		}
		return super.getValue(key);
	}

	private function createExecuter():ICommand{
		var cmd:ExecuteValue = new ExecuteValue();
		cmd.name = NodeSystem.getUniqueName();
		return cmd;
	}
}
}