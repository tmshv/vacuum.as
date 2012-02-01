package ru.gotoandstop.nodes{
import flash.events.Event;
import flash.events.EventDispatcher;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.values.IValue;

/**
	 *
	 * creation date: Jan 27, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class ExecuteValue extends EventDispatcher implements IValue, ICommand{
		public function ExecuteValue(){
			super();
		}
		
		private var _name:String;
		
		public function get name():String{
			return this._name;
		}
		
		public function set name(value:String):void
		{
			this._name = value;
		}
		
		public function getValue():*
		{
			return null;
		}
		
		public function setValue(value:*):void{
			this.update();
		}
		
		public function update():void{
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function execute():void{
			this.update();
		}
	}
}