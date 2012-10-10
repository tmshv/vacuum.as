/**
 * Created with IntelliJ IDEA.
 * User: tmshv
 * Date: 5/26/12
 * Time: 4:39 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.vacuum.core {
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;

import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.TargetVertex;

public class LayoutVertex extends TargetVertex {
    private var _layout:Layout;

    public var considerLayoutScale:Boolean = true;
    public var considerLayoutCenter:Boolean = true;
    public var considerLayoutRotation:Boolean = true;

    public function LayoutVertex(original:IVertex) {
        super(original);
    }

    public function setLayout(layout:Layout):void {
        if (_layout) {
            _layout.removeEventListener(Event.CHANGE, recalc);
        }
        _layout = layout;
        if (_layout) {
            _layout.addEventListener(Event.CHANGE, recalc);
        }
        recalc();
    }

    override public function dispose():void {
        if (_layout) {
            _layout.removeEventListener(Event.CHANGE, recalc);
        }
        super.dispose();
    }

    private function recalc(event:Event=null):void {
        setCoordToYourself(target.x, target.y);
    }

    private function setTargetCoord(x:Number, y:Number):void{
        if(target) target.setCoord(x, y);
    }

    override public function setCoord(x:Number, y:Number):void {
        var coord:Point = new Point(x, y);
        coord = _layout ? _layout.invertLayout(coord) : coord;
        setTargetCoord(coord.x, coord.y);
    }

    private function transformValue(value:Number, center:Number, scale:Number, rotation:Number):Number {
        value = considerLayoutScale ? value * scale : value;
        value = considerLayoutCenter ? center + value : value;
        return value;
    }

    override protected function setCoordToYourself(x:Number, y:Number):void {
        var coord:Point = new Point(x, y);
        coord = _layout ? _layout.applyLayout(coord) : coord;
        super.setCoordToYourself(coord.x,  coord.y);
    }
}
}
