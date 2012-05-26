/**
 *
 * User: tmshv
 * Date: 5/12/12
 * Time: 6:33 PM
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;

import ru.gotoandstop.command.ICommand;

import ru.gotoandstop.nodes.core.NodeChangeEvent;

import ru.gotoandstop.nodes.core.NodeObject;

public class ConditionObject extends NodeObject{
    public function ConditionObject() {
        super.addEventListener(Event.CHANGE, handleChange);
    }

    private function handleChange(event:Event):void {
        const change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            var key:String = change.key;
            if (key == "if") {
                update();
            }
        }
    }

    override public function update():void {
        var i:Boolean = get("if");
        if(i){
            set("then", Math.random());
        }else{
            set("else", Math.random());
        }
        super.update();
    }

    override public function dispose():void {
        super.removeEventListener(Event.CHANGE, handleChange);
        super.dispose();
    }
}
}
