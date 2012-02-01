package ru.gotoandstop.nodes{
import ru.gotoandstop.mvc.BaseModel;

/**
	 * @author tmshv
	 */
	public class NodeModel extends BaseModel implements INode{
		private var _name:String;

		public function get name():String{
			return this._name;
		}
		
		public function set name(value:String):void{
			this._name = value;
		}

		public function get type():String{
			return 'base';
		}

		public function getValue(key:String):*{
			return this[key];
		}

		public function setValue(key:String, value:*):void{
			this[key] = value;
		}

		public function getParams():Vector.<String>{
			return null;
		}
		
		public function NodeModel(){
			
		}
	}
}
