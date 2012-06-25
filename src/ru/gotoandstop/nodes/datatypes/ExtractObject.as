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
        on("input", handleChange);
        on("field", handleChange);
    }

    private function handleChange(event:Event):void {
        update();
    }

    override public function update():void {
        var input:Object = get("input");
        var field:String = get("field");
        if(input && field) {
            var e:Object = input[field];
            if(e != undefined) {
                set("output", e);
            }else{
                set("output", null);
            }
        }
        super.update();
    }

    override public function dispose():void {
        off("input", handleChange);
        off("field", handleChange);
        super.dispose();
    }
}
}
