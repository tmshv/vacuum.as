package ru.gotoandstop.nodes.datatypes{
import ru.gotoandstop.nodes.*;

import flash.events.Event;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.values.IValue;

/**
	 *
	 * creation date: Jan 27, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class PrintNode extends NodeModel{
		public var msg:String = '';
		private var _cmd:IValue;
		
		public override function get type():String{
			return NodeType.PRINT;
		}
		
		public function PrintNode(){
			
		}
		
		internal function setMessage(msg:String):void{
			this.msg = msg;
		}
		
		public override function setKeyValue(key:String, value:*):void{
			if(key == 'cmd'){
				if(this._cmd) this._cmd.removeEventListener(Event.CHANGE, this.handleChange);
				
				if(value){
					this._cmd = value;
					this._cmd.addEventListener(Event.CHANGE, this.handleChange);
				}else{
					this._cmd = null;
				}
			}else{
				super.setKeyValue(key, value);
			}

//			trace('add node', key, value);
//			var v:IValue = value as IValue;
//			if(key == 'first'){
//				if(this.firstValue) this.firstValue.removeEventListener(Event.CHANGE, this.handleChange);
//				if(value is IValue){
//					this.firstValue = value;
//					if(this.firstValue) this.firstValue.addEventListener(Event.CHANGE, this.handleChange);
//					this.calc();
//					
//					this.first = v.name;
//				}
//			}else if(key == 'second'){
//				if(this.secondValue) this.secondValue.removeEventListener(Event.CHANGE, this.handleChange);
//				if(value is IValue){
//					this.secondValue = value;
//					if(this.secondValue) this.secondValue.addEventListener(Event.CHANGE, this.handleChange);
//					this.calc();
//					
//					this.second = v.name;
//				}
//			}
		}
		
		private function handleChange(event:Event):void{
//			var print:ICommand = new PrintCommand(this.msg);
//			print.execute();
		}
		
		public override function getKeyValue(key:String):*{
//			if(key == 'first'){
//				return this.firstValue;
//			}else if(key == 'second'){
//				return this.secondValue;
//			}
			return super.getKeyValue(key);
		}
	}
}