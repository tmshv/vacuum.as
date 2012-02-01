package ru.gotoandstop.nodes{
import flash.display.DisplayObjectContainer;

/**
	 *
	 * creation date: Jan 21, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class NumberNodeBuiler extends BaseNodeBuilder{
		public function NumberNodeBuiler(){
			super._type = NodeType.NUMBER;
		}
		
		public override function init(vo:NodeVO, container:DisplayObjectContainer, vacuum:VacuumLayout):void{
			super.init(vo, container, vacuum);
			var exclude:Vector.<Object> = new Vector.<Object>;
			exclude.push(/instance[\d]+/);
			exclude.push('numberValue');
			this.vo.exclude = exclude;
		}
		
		public override function createNode(name:String, model:INode=null):Node{
			var model_instance:NumberNode = model ? model as NumberNode : new NumberNode();
//			model_instance.setValue('value', int(Math.random()*100));
			var view:NodeView = new NumberNodeView(model_instance, this.vacuum, this.vo);
			//var node:Node = new Node(this.container, this.vacuum, name, model, view, this.vo);
			var node:Node = new Node();
			node.container = this.container;
			node.vacuum = this.vacuum;
			node.model = model_instance;
			node.view = view;
			node.vo = this.vo;
			node.name = name;
			node.init();
			
//			node.valuesDict = {
//				valueOut: ['value', 'out']
//			}
			
			return node;
		}
	}
}