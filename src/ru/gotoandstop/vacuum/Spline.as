package ru.gotoandstop.vacuum {
import flash.display.GraphicsPath;
import flash.events.IEventDispatcher;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.VertexGroup;

[Event(name="change", type="flash.events.Event")]

/**
 *
 * Creation date: May 1, 2011 (1:24:59 AM)
 * @author Roman Timashev (roman@tmshv.ru)
 */
public class Spline extends VertexGroup {
    private var controls:Vector.<Boolean> = new Vector.<Boolean>();

    private var _closed:Boolean;
    public function get closed():Boolean {
        return this._closed;
    }

    public function set closed(value:Boolean):void {
        this._closed = value;
        this.changed = true;
        this.update();
    }

    public function Spline(target:IEventDispatcher, onEnterFrame:Boolean = true, closed:Boolean = false) {
        super(target, onEnterFrame);
        _closed = closed;
    }

    override public function addVertex(vertex:IVertex):void {
        addVertex2(vertex);
    }

    public function addVertex2(vertex:IVertex, asControl:Boolean = false):void {
        this.controls.push(asControl);
        super.addVertex(vertex);
    }

    public function markAsControl(vertex:IVertex):void {

    }

    public function getCommands():GraphicsPath {
        var data:GraphicsPath = new GraphicsPath();

        //nothing to draw
        if (_list.length < 2) {
            return data;
        }

        var vertices:Vector.<IVertex> = _list.concat();
        var controls:Vector.<Boolean> = controls.concat();

        if (this.closed) {
            vertices.push(_list[0]);
            controls.push(controls[0]);
        }

        var first:IVertex = vertices.shift();
        controls.shift();
        data.moveTo(first.x, first.y);

        var length:uint = vertices.length;
        for (var i:uint = 0; i < length; i++) {
            var draw_cubic_bezier:Boolean = false;
            var draw_quadrantic_bezier:Boolean = false;

            var v1:IVertex = vertices[i];
            var c1:Boolean = controls[i];
            var c2:Boolean;

            //можно нарисовать куад-безье
            if (length - i > 2) {
                c2 = controls[i + 1];

                //в правилах указано нарисовать куад-безье
                if (c1 && c2) {
                    draw_cubic_bezier = true;
                }
            }

            draw_quadrantic_bezier = length - i > 1 && c1;

            // нарисуется кривая
            if (draw_cubic_bezier || draw_quadrantic_bezier) {
                var v2:IVertex = vertices[i + 1];
                if (draw_cubic_bezier) {
                    var c3:Boolean = controls[i + 2];
                    var v3:IVertex = vertices[i + 2];
                    if (!c3) data.cubicCurveTo(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
                    i += 1;
                } else if (draw_quadrantic_bezier) {
                    c2 = controls[i + 1];
                    if (!c2) data.curveTo(v1.x, v1.y, v2.x, v2.y);
                }
            }

            // нарисуется линия
            else {
                if (!c1) data.lineTo(v1.x, v1.y);
            }
        }

        return data;
    }

    private function getDrawLineData():GraphicsPath {
        var first:IVertex = _list[0];
        var second:IVertex = _list[1];

        var data:GraphicsPath = new GraphicsPath();
        data.moveTo(first.x, first.y);
        data.lineTo(second.x, second.y);

        return data;
    }

    private function getDrawCurveLineData():GraphicsPath {
        var first:IVertex = _list[0];
        var second:IVertex = _list[1];
        var third:IVertex = _list[2];

        var data:GraphicsPath = new GraphicsPath();
        data.moveTo(first.x, first.y);
        data.curveTo(second.x, second.y, third.x, third.y);

        return data;
    }

    private function drawCubicCurve(path:GraphicsPath, c1:IVertex, c2:IVertex, a:IVertex):void {
        path.cubicCurveTo(c1.x, c1.y, c2.x, c2.y, a.x, a.y);
    }

    public function getLineList():Vector.<Line> {
        var list:Vector.<Line> = new Vector.<Line>();
        const length:uint = list.length - 1;
        for (var i:uint; i < length; i++) {
            var v1:IVertex = _list[i];
            var v2:IVertex = _list[i + 1];
            list.push(new Line(v1, v2));
        }
        if (this.closed) {
            list.push(new Line(_list[length], _list[0]));
        }
        return list;
    }
}
}