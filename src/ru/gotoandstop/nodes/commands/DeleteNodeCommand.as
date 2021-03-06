/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 30.01.12
 * Time: 14:43
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.commands {
import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.core.INode;

public class DeleteNodeCommand implements ICommand {
    private var _node:INode;
    private var _kill:Function;

    public function DeleteNodeCommand(node:INode, kill:Function) {
        _node = node;
        _kill = kill;
    }

    public function execute(data:Object = null):void {
        _kill(_node);
    }
}
}
