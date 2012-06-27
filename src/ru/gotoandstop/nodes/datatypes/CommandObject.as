/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/7/12
 * Time: 5:06 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;
import flash.events.EventDispatcher;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.INodeSystem;
import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.nodes.datatypes.ActionObject;
import ru.gotoandstop.values.IValue;

public class CommandObject extends ActionObject implements ICommand {
    public var command:ICommand;
    public var reserve:Boolean = false;

    public function CommandObject() {
        super();
//        super.addEventListener(Event.CHANGE, handleChange);
    }


    override protected function executeAction():void {
        var data:Object = get("init");
        if (!data) data = {};
        if (reserve) {
            data.next = super.executeAction;
            execute(data);
        } else {
            execute(data);
            super.executeAction();
        }
    }

    public function execute(data:Object = null):void {
        if (command) {
            command.execute(data);
        }else{
            var Cmd:Class = super.system.storage.get(super.type + ".command");
            try{
                var c:ICommand = new Cmd();

            }catch(error:Error){

            }

            if(c) c.execute(data);
        }
    }

//	private function handleChange(event:Event):void {
//        var change:NodeChangeEvent = event as NodeChangeEvent;
//        if(change) {
//            if(change.key == "init" && Boolean(change.value)){
//                execute(get("init"));
//            }
//        }
//	}
//
//    public function execute(data:Object = null):void {
//        if (command) {
//            command.execute(data);
//        }
//        executeAction();
//    }

    override public function dispose():void {
//        super.removeEventListener(Event.CHANGE, handleChange);
        command = null;
        super.dispose();
    }
}
}
