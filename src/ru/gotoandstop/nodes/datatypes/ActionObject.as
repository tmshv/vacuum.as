/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/14/12
 * Time: 9:49 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.nodes.core.NodeObject;
import ru.gotoandstop.nodes.core.NodeSystem;
import ru.gotoandstop.nodes.core.TransportOrigin;
import ru.gotoandstop.values.IValue;

public class ActionObject extends NodeObject {
    private var _overridedCommand:ICommand;

    public function ActionObject() {
        super.set('init', 0);
        super.set('done', 0);
    }

    public function overrideAction(cmd:ICommand):void {
        _overridedCommand = cmd;
    }

    override protected function notifyAbout(key:String, value:*):void {
        super.notifyAbout(key, value);
        var p:String = param(key);
        if(p == "init"){
            var origin:String = lastTransfer ? lastTransfer.origin : '';
            var changing_is_update:Boolean = origin == TransportOrigin.NODE_UPDATE;
            var value_is_valid:Boolean = value != null && value != undefined;
            if (value_is_valid && changing_is_update) {
                if (_overridedCommand) {
                    _overridedCommand.execute();
                } else {
                    executeAction();
                }
            }
        }
    }

    protected function executeAction():void {
        var done:Object = get("init");
        set('done', done);
    }

    override public function dispose():void {
        super.dispose();
    }
}
}