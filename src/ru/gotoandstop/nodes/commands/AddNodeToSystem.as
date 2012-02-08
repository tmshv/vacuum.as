package ru.gotoandstop.nodes.commands{
import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.Node;
import ru.gotoandstop.nodes.core.NodeSystem;

/**
	 * @author tmshv
	 */
	public class AddNodeToSystem implements ICommand{
		private var type:String;
		private var sys:NodeSystem;

		public function AddNodeToSystem(type:String, sys:NodeSystem){
			this.type = type;
			this.sys = sys;
		}

		public function execute():void{
			var node:Node = this.sys.addNode(this.type);
			node.view.setCoord(400, 300);
		}
	}
}
