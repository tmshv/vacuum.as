/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 30.01.12
 * Time: 14:43
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.commands {
import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.Node;

public class DeleteNodeCommand implements ICommand{
	private var _node:Node;
	private var _kill:Function;
	
	public function DeleteNodeCommand(node:Node, kill:Function) {
		_node = node;
		_kill = kill;
	}

	public function execute():void {
		_kill(_node);
	}
}
}
