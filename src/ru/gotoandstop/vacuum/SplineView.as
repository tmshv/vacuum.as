package ru.gotoandstop.vacuum {
import flash.display.GraphicsPath;
import flash.display.Sprite;
import flash.events.Event;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.render.IDrawer;

/**
 *
 * Creation date: May 1, 2011 (2:01:47 AM)
 * @author Roman Timashev (roman@tmshv.ru)
 */
public class SplineView extends Sprite implements IDisposable {
    private var _spline:Spline;
    public function get spline():Spline {
        return _spline;
    }

    private var _drawer:IDrawer;
    public function get drawer():IDrawer {
        return _drawer;
    }
    public function set drawer(value:IDrawer):void {
        _drawer = value;
        drawSpline2(_lastGraphics);
    }

    private var _lastGraphics:GraphicsPath;

    public function SplineView(spline:Spline) {
        super();
        _spline = spline;
        _spline.addEventListener(Event.CHANGE, this.handleSplineChanged);
        drawSpline2(_spline.getCommands());
    }

    public function dispose():void {
        spline.removeEventListener(Event.CHANGE, this.handleSplineChanged);
        _spline = null;
    }

    private function handleSplineChanged(event:Event):void {
        drawSpline2(spline.getCommands());
    }

    private function drawSpline2(data:GraphicsPath):void {
        _lastGraphics = data;
        if (_drawer) {
            _drawer.draw(graphics, _lastGraphics)
        } else {
            graphics.clear();
            graphics.lineStyle(0, 0x000000);
            graphics.drawPath(_lastGraphics.commands, _lastGraphics.data, _lastGraphics.winding);
        }
    }
}
}