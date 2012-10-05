package ru.gotoandstop.vacuum {
import flash.events.Event;
import flash.geom.Point;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.TargetVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
 * @author tmshv
 */
public class RelativeVertex extends TargetVertex {
    private var offset:IVertex;
    public var layoutCenter:Boolean = false;

    public function RelativeVertex(targetVertex:IVertex, offsetVertex:IVertex) {
        super(targetVertex);
        target.onChange(recalc);
        offset = offsetVertex;
        offset.onChange(recalc);
        recalc();
    }

    private function recalc(event:Event = null):void {
        var base:Point = target.getCoord({layoutCenter:layoutCenter});
        var x:Number = base.x + this.offset.x;
        var y:Number = base.y + this.offset.y;
        super.setCoord(x, y);
    }

    override public function dispose():void {
        target.offChange(recalc);
        offset.offChange(recalc);
        _target = null;
        offset = null;
    }
}
}
