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
        offset = offsetVertex;
        offset.onChange(recalc);
        recalc();
    }

    private function recalc(event:Event = null):void {
        setCoordToYourself(target.x, target.y);
    }

    override public function dispose():void {
        super.dispose();
        if (offset) offset.offChange(recalc);
        offset = null;
    }

    override protected function setCoordToYourself(x:Number, y:Number):void {
        if (offset) {
            x += offset.x;
            y += offset.y;
        }
        super.setCoordToYourself(x, y);
    }
}
}
