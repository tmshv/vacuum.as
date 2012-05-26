/**
 *
 * User: tmshv
 * Date: 5/12/12
 * Time: 6:19 PM
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;

import ru.gotoandstop.nodes.core.NodeChangeEvent;

import ru.gotoandstop.nodes.core.NodeObject;

public class ExtractObject extends NodeObject {
    public function ExtractObject() {
        super.addEventListener(Event.CHANGE, handleChange);
    }

    private function handleChange(event:Event):void {
        const change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            var key:String = change.key;
            if (key == "input") {
                update();
            } else if (key == "field") {
                update();
            }
        }
    }

    override public function update():void {
        var input:Object = get("input");
        var field:String = get("field");
        if(input && field) {
            var e:Object = input[field];
            if(e != undefined) {
                set("output", e);
            }
        }
        super.update();
    }

    override public function dispose():void {
        super.removeEventListener(Event.CHANGE, handleChange);
        super.dispose();
    }
}
}
