package ru.gotoandstop.nodes{
import flash.display.DisplayObjectContainer;

/**
	 *
	 * creation date: Jan 21, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class OutputNodeBuilder extends BaseNodeBuilder{
		public function OutputNodeBuilder(){
			super._type = NodeType.OUTPUT;
		}
		
		public override function init(vo:NodeVO, container:DisplayObjectContainer, vacuum:VacuumLayout):void{
			super.init(vo, container, vacuum);
			var exclude:Vector.<Object> = new Vector.<Object>;
			exclude.push(/instance[\d]+/);
			exclude.push('output');
			this.vo.exclude = exclude;
		}
		
		public override function createNode(name:String, model:INode=null):Node{
			var model_instance:OutputNode = model ? model as OutputNode : new OutputNode();
			var view:NodeView = new OutputNodeView(model_instance, this.vacuum, this.vo);
//			var node:Node = new Node(this.container, this.vacuum, name, model, view, this.vo);
			var node:Node = new Node();
			node.container = this.container;
			node.vacuum = this.vacuum;
			node.model = model_instance;
			node.view = view;
			node.vo = this.vo;
			node.name = name;
			node.init();
			return node;
		}
	}
}