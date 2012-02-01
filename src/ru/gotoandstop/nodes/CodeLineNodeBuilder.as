package ru.gotoandstop.nodes
{
import flash.display.DisplayObjectContainer;

/**
	 * ...
	 * @author Roman Timashev
	 */
	public class CodeLineNodeBuilder extends BaseNodeBuilder
	{
		
		private var code:String;
		private var Model:Class;
		private var fields:Array;
		
		public function CodeLineNodeBuilder(type:String, Model:Class, fields:Array, code:String)
		{
			super();
			super._type = type;
			this.code = code;
			this.Model = Model;
			this.fields = fields;
		}
		
		public override function init(vo:NodeVO, container:DisplayObjectContainer, vacuum:VacuumLayout):void
		{
			super.init(vo, container, vacuum);
		}
		
		public override function createNode(name:String, model:INode = null):Node
		{
			var model_instance:INode = model ? model : new Model();
			//for each (var item:Object in this.fields) 
			//{
				//for (var name:String in item) 
				//{
					//if (name == 'type') {
						//
					//}else {
						//model_instance.setValue(name, null);
					//}
				//}
			//}
			
			
			var view:NodeView = new CodeLineNodeView(model_instance, this.code, this.vacuum, this.vo);
			var node:Node = new Node();
			node.container = this.container;
			node.vacuum = this.vacuum;
			node.model = model_instance;
			node.view = view;
			node.vo = this.vo;
			node.name = name;
			node.autoValues = PortPointType.IN;
			node.init();
			return node;
		}
	
	}

}