package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.*;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.NodeSystem;
import ru.gotoandstop.nodes.datatypes.ActionObject;
import ru.gotoandstop.values.IValue;
import ru.gotoandstop.values.NumberValue;

public class TimeoutObject extends ActionObject{
	private var _timeoutID:uint;

	public function TimeoutObject() {

	}

    override protected function executeAction():void {
        var delay:uint = get("delay");
        _timeoutID = setTimeout(timeout, delay);
    }

    private function timeout():void{
        super.executeAction();
    }

    override public function dispose():void {
        clearTimeout(_timeoutID);
        super.dispose();
    }
}
}