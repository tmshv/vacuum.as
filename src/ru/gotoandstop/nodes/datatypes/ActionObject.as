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
import ru.gotoandstop.nodes.core.NodeSystem;
import ru.gotoandstop.nodes.core.SimpleNodeObject;
import ru.gotoandstop.values.IValue;

public class ActionObject extends SimpleNodeObject{
    private var _initObjectName:String;
    public function get init():String {
        return _initObjectName;
    }

    private var _init:IValue;
    protected var _done:ICommand;

    public function ActionObject() {
        _done = createExecuter();
    }

    override public function setKeyValue(key:String, value:*):void {
        if (key == 'init') {
            if (_init) _init.removeEventListener(Event.CHANGE, handleChange);

            if (value is IValue) {
                _init = value;
                _init.addEventListener(Event.CHANGE, handleChange);
                _initObjectName = this._init.name;
            } else {
                _init = null;
                _initObjectName = '';
            }
        } else {
            super.setKeyValue(key, value);
        }
    }

    override public function getKeyValue(key:String):* {
        if(key == 'done'){
            return _done;
        }
        return super.getKeyValue(key);
    }

    protected function handleChange(event:Event):void {
        _done.execute();
    }

    override public function dispose():void {
        if(_init) _init.removeEventListener(Event.CHANGE, handleChange);
        _init = null;
        _done = null;
        super.dispose();
    }

    private function createExecuter():ICommand {
        var cmd:ExecuteValue = new ExecuteValue();
        cmd.name = NodeSystem.getUniqueName();
        return cmd;
    }

    override public function getParams():Vector.<String> {
        var list:Vector.<String> = super.getParams();
        list.push('init');
        list.push('done');
        return list;
    }
}
}
