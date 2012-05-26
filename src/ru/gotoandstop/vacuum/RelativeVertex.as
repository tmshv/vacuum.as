package ru.gotoandstop.vacuum {
import flash.events.Event;
import flash.geom.Point;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
 * @author tmshv
 */
public class RelativeVertex extends Vertex {
    private var target:IVertex;
    private var offset:IVertex;

    public var layoutCenter:Boolean = false;

    public function RelativeVertex(target:IVertex, offset:IVertex) {
        super();
        this.target = target;
        this.target.addEventListener(Event.CHANGE, this.recalc);
        this.offset = offset;
        this.offset.addEventListener(Event.CHANGE, this.recalc);
        this.recalc();
    }

    private function recalc(event:Event = null):void {
        var base:Point = target.getCoord({layoutCenter:layoutCenter});
        var x:Number = base.x + this.offset.x;
        var y:Number = base.y + this.offset.y;
        super.setCoord(x, y);
    }

    public function dispose():void {
        this.target.removeEventListener(Event.CHANGE, this.recalc);
        this.offset.removeEventListener(Event.CHANGE, this.recalc);
        this.target = null;
        this.offset = null;
    }
}
}
