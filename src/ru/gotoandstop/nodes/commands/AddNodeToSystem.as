package ru.gotoandstop.nodes.commands {
import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.INodeSystem;

/**
 * @author tmshv
 */
public class AddNodeToSystem implements ICommand {
    private var type:String;
    private var sys:INodeSystem;
    private var model:Object;

    public function AddNodeToSystem(type:String, sys:INodeSystem, model:Object = null) {
        this.type = type;
        this.sys = sys;
        this.model = model;
    }

    public function execute(data:Object = null):void {
        var node:INode = sys.createNode(type, model);
    }
}
}
