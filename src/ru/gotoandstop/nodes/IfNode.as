package ru.gotoandstop.nodes{
import flash.events.Event;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.ExecuteValue;
import ru.gotoandstop.nodes.NodeModel;
import ru.gotoandstop.nodes.NodeSystem;
import ru.gotoandstop.nodes.NodeType;
import ru.gotoandstop.values.IValue;

/**
	 *
	 * creation date: Jan 27, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class IfNode extends NodeModel{
		private var _boolean:IValue;
		public var boolean:String;
		
		private var thenCommand:ICommand;
		private var elseCommand:ICommand;
		
		public override function get type():String{
			return NodeType.IF;
		}
		
		public function IfNode(){
			super();
			
			this.thenCommand = this.createExecuter();
			this.elseCommand = this.createExecuter();
		}
		
		public override function setValue(key:String, value:*):void{
			if(key == 'boolean'){
				if(this._boolean) this._boolean.removeEventListener(Event.CHANGE, this.handleChange);
				
				if(value is IValue){
					this._boolean = value;
					this._boolean.addEventListener(Event.CHANGE, this.handleChange);
					this.boolean = this._boolean.name;
					this.handleChange(null);
				}else{
					this._boolean = null;
				}
			}else{
				super.setValue(key, value);
			}
		}
		
		private function handleChange(event:Event):void{
			const bool:Boolean = Boolean(this._boolean.getValue());
			if(bool){
				this.thenCommand.execute();
			}else{
				this.elseCommand.execute();
			}
		}
		
		public override function getValue(key:String):*{
			if(key == 'then'){
				return this.thenCommand;
			}else if(key == 'else'){
				return this.elseCommand;
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