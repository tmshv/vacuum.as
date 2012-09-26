/**
 *
 * User: tmshv
 * Date: 5/22/12
 * Time: 9:41 PM
 */
package ru.gotoandstop.nodes.datatypes {
import flash.events.Event;

import ru.gotoandstop.nodes.core.NodeChangeEvent;

import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.nodes.core.NodeObject;

public class Coord2DObject extends NodeObject{
    public function Coord2DObject() {
        on("x", handleChange);
        on("y", handleChange);
    }

    private function handleChange(event:Event):void {
        set("coord", {
            x:Number(get("x")),
            y:Number(get("y"))
        });
        update();
    }


    override public function dispose():void {
        off("x", handleChange);
        off("y", handleChange);
        super.dispose();
    }
}
}
