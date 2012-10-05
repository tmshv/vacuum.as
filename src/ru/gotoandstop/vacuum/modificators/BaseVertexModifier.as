/**
 *
 * User: tmshv
 * Date: 10/5/12
 * Time: 5:34 PM
 */
package ru.gotoandstop.vacuum.modificators {
import flash.geom.Point;

public class BaseVertexModifier implements IVertexModifier{
    private var _active:Boolean;

    public function BaseVertexModifier() {
        active = true;
    }

    public function modify(x:Number, y:Number):Point {
        if(active) return new Point(x, y);
        else return new Point(x, y);
    }

    public function get active():Boolean {
        return _active;
    }

    public function set active(value:Boolean):void {
        _active = value;
    }
}
}
