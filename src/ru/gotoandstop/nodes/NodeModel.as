package ru.gotoandstop.nodes{
import ru.gotoandstop.mvc.BaseModel;
import ru.gotoandstop.nodes.datatypes.INode;

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

		public function getKeyValue(key:String):*{
			return this[key];
		}

		public function setKeyValue(key:String, value:*):void{
			this[key] = value;
		}

		public function getParams():Vector.<String>{
			return null;
		}
		
		public function NodeModel(){
			
		}
	}
}
