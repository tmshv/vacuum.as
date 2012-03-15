/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/9/12
 * Time: 6:45 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.vacuum.core {
import flash.geom.Point;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.modificators.IVertexModifier;

public class ModifiableVertex extends Vertex {
    private var modifiers:Vector.<IVertexModifier>;

    public function ModifiableVertex(x:Number = 0, y:Number = 0) {
        super(x, y);
        modifiers = new Vector.<IVertexModifier>();
    }

    override public function setCoord(x:Number, y:Number):void {
        var new_coord:Point = new Point(x, y);
        for each(var ctrl:IVertexModifier in modifiers) {
            new_coord = ctrl.modify(new_coord.x, new_coord.y);
        }
        super.setCoord(new_coord.x, new_coord.y);
    }

    public function addModifier(modifier:IVertexModifier):void {
        modifiers.push(modifier);
    }
}
}
