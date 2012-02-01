/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/1/12
 * Time: 6:20 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes {
import ru.gotoandstop.nodes.TimeoutNode;
import ru.gotoandstop.nodes.TimeoutNode;

public class TimeoutNodeBuilder extends BaseNodeBuilder{
	override public function get type():String {
		return 'timeout';
	}

	public function TimeoutNodeBuilder() {
	}

	public override function createNode(name:String, model:INode=null):Node{
		var model_instance:TimeoutNode = model ? model as TimeoutNode : new TimeoutNode();
		var view:NodeView = new TimeoutNodeView(model_instance, vacuum, vo);
		var node:Node = new Node();
		node.container = container;
		node.vacuum = vacuum;
		node.model = model_instance;
		node.view = view;
		node.vo = vo;
		node.name = name;
		node.init();

		return node;
	}
}
}
