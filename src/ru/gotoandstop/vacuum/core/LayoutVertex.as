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
        setCoord(target.x, target.y);
    }

//    public static function screenToLayout(view:VertexView, x:Number, y:Number):Point {
//        return new Point(
//                (x - view.layout.center.x) / view.layout.scale.value,
//                (y - view.layout.center.y) / view.layout.scale.value
//        );
//    }
//
//    public function screenCoordToIdeal(x:Number, y:Number):Point {
//        return new Point(
//                (x - layout.center.x) / this.layout.scale.value,
//                (y - layout.center.y) / this.layout.scale.value
//        );
//    }


    override public function setCoord(x:Number, y:Number):void {
        var coord:Point = new Point(x, y);
        var new_coord:Point = _layout ? _layout.screenToLayout(coord) : coord;
        super.setCoord(new_coord.x, new_coord.y);
    }

//    override public function set x(value:Number):void {
//        var center:Number = 0;
//        var scale:Number = 1;
//        var rotation:Number = 0;
//        if (_layout) {
//            center = _layout.center.x;
//            scale = _layout.scale.value;
//        }
//        super.x = transformValue(value, center, scale, rotation);
//    }
//
//    override public function set y(value:Number):void {
//        var center:Number = 0;
//        var scale:Number = 1;
//        var rotation:Number = 0;
//        if (_layout) {
//            center = _layout.center.y;
//            scale = _layout.scale.value;
//        }
//        super.y = transformValue(value, center, scale, rotation);
//    }

    private function transformValue(value:Number, center:Number, scale:Number, rotation:Number):Number {
        value = considerLayoutScale ? value * scale : value;
        value = considerLayoutCenter ? center + value : value;
        return value;
    }
}
}
