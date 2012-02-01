package ru.gotoandstop.nodes{
import flash.display.DisplayObjectContainer;

/**
	 *
	 * creation date: Jan 21, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class BaseNodeBuilder implements INodeBuilder{
		protected var vo:NodeVO;
		protected var container:DisplayObjectContainer;
		protected var vacuum:VacuumLayout;
		
		protected var _type:String;
		public function get type():String{
			return this._type;
		}
		
		public function BaseNodeBuilder(){
			
		}
		
		public function init(vo:NodeVO, container:DisplayObjectContainer, vacuum:VacuumLayout):void{
			this.vo = vo;
			this.container = container;
			this.vacuum = vacuum;
		}
		
		public function createNode(name:String, model:INode=null):Node{
			return null;
		}
	}
}