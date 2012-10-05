package ru.gotoandstop.vacuum.modificators {
import flash.geom.Point;

import ru.gotoandstop.math.Calculate;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.modificators.BaseVertexModifier;

/**
 *
 * @author Roman Timashev (roman@tmshv.ru)
 **/
public class SnapModifier extends BaseVertexModifier{
    private var list:Vector.<IVertex>;
    private var thresholdQuad:uint;

    public function SnapModifier(list:Vector.<IVertex>, threshold:uint = 10) {
        super();
        this.list = list;
        thresholdQuad = threshold * threshold;
    }

    override public function modify(x:Number, y:Number):Point {
        var coord:Point = new Point(x, y);
        if (active) {
            for each(var vtx:Vertex in this.list) {
                var vtx_coord:Point = vtx.toPoint();
                var dist:Number = Calculate.distanceQuad(vtx_coord, coord);
                if (dist < thresholdQuad) {
                    return vtx_coord;
                }
            }
        }
        return coord;
    }
}
}