/**
 *
 * User: tmshv
 * Date: 5/22/12
 * Time: 9:41 PM
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;

import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.nodes.core.NodeObject;

public class Coord2DObject extends NodeObject{
    public function Coord2DObject() {
        super.addEventListener(Event.CHANGE, handleChange);
    }

    private function handleChange(event:Event):void {
        const change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            if (change.key == "x" || change.key == "y") {
                update();
            }
        }
    }

    override public function update():void {
        set("coord", {
            x:Number(get("x")),
            y:Number(get("y"))
        });
        super.update();
    }
}
}
