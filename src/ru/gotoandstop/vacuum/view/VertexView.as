package ru.gotoandstop.vacuum.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.values.BooleanValue;

[Event(name="change", type="flash.events.Event")]

/**
 * Класс занимается отрисовкой точки <code>vertex<code> на экране
 * Creation date: Jun 2, 2011 (1:33:42 PM)
 * @author Roman Timashev (roman@tmshv.ru)
 */
public class VertexView extends Sprite implements IDisposable, IVertex {
    public static function screenToLayout(view:VertexView, x:Number, y:Number):Point {
        return new Point(
                (x - view._layout.center.x) / view._layout.scale.value,
                (y - view._layout.center.y) / view._layout.scale.value
        );
    }

    private var _active:BooleanValue;
    /**
     * Булево значение, отвечающее за состояние точки. true - вьюшка будет слушать модель.
     * @return
     *
     */
    public function get active():BooleanValue {
        return this._active;
    }

    private var _vertex:IVertex;
    /**
     * модель данных для отрисовки
     * @return
     *
     */
    public function get vertex():IVertex {
        return this._vertex;
    }

    private var _icon:VertexIcon;
    /**
     * Внешний вид точки
     * @return
     *
     */
    public function get icon():VertexIcon {
        return this._icon;
    }

    private var _layout:Layout;
    public var considerScaleLayout:Boolean = true;

    public function VertexView(vertex:IVertex, layout:Layout, icon:VertexIcon = null, considerScaleLayout:Boolean = true) {
        super();
        this.considerScaleLayout = considerScaleLayout;
        _active = new BooleanValue();
        setIcon(icon ? icon : new EmptyIcon());

        _layout = layout;
        _layout.scale.addEventListener(Event.CHANGE, this.handleLayoutChange);
        _layout.center.addEventListener(Event.CHANGE, this.handleLayoutChange);
        _vertex = vertex;

        this.vertex.addEventListener(Event.CHANGE, this.handleVertexChange);
        configure(vertex);
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
    }

    public function update():void {
        super.dispatchEvent(new Event(Event.CHANGE));
    }

    public function onChange(listener:Function, useWeakReference:Boolean = false):void {
        super.addEventListener(Event.CHANGE, listener, false, 0, useWeakReference);
    }

    public function offChange(listener:Function):void {
        super.removeEventListener(Event.CHANGE, listener);
    }

    public function dispose():void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        this.vertex.removeEventListener(Event.CHANGE, this.handleVertexChange);
        this._layout.scale.removeEventListener(Event.CHANGE, this.handleLayoutChange);
        this._layout.center.removeEventListener(Event.CHANGE, this.handleLayoutChange);

        removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
    }

    public function setCoord(x:Number, y:Number):void {
        x = (x - _layout.center.x) * _layout.scale.value;
        y = (y - _layout.center.y) * _layout.scale.value;

        this.vertex.setCoord(x, y);
    }

    public function getCoord(params:Object = null):Point {
        if (params) {
            var l_to_g:Point = params.localToGlobal;
            if (l_to_g) {
                return super.localToGlobal(l_to_g);
            }

            if (params.layoutCenter) {
                return new Point(x - _layout.center.x, y - _layout.center.y);
            }
        }
        return new Point(this.x, this.y);
    }

    public function toPoint():Point {
        return new Point(this.x, this.y);
    }

    public function setIcon(icon:VertexIcon):void {
        if (_icon) {
            super.removeChild(_icon);
        }
        _icon = icon;
        super.addChild(_icon);
    }

    public function getPosition(withLayout:Boolean = false):Point {
        if (withLayout) {
            var x:Number = (super.x - this._layout.center.x) / this._layout.scale.value;
            var y:Number = (super.y - this._layout.center.y) / this._layout.scale.value;
            return new Point(x, y);
        } else {
            return new Point(super.x, super.y);
        }
    }

    public function screenCoordToIdeal(x:Number, y:Number):Point {
        return new Point(
                (x - _layout.center.x) / this._layout.scale.value,
                (y - _layout.center.y) / this._layout.scale.value
        );
    }

    /**
     * Устанавливает вьюшку в координату, соответстующую <code>vertex</code>.
     * @param vertex
     *
     */
    private function configure(vertex:IVertex):void {
        var dx:Number = considerScaleLayout ? vertex.x * this._layout.scale.value : vertex.x;
        var dy:Number = considerScaleLayout ? vertex.y * this._layout.scale.value : vertex.y;
        super.x = this._layout.center.x + dx;
        super.y = this._layout.center.y + dy;

        update();
    }

    private function handleMouseDown(event:MouseEvent):void {
        this.active.value = true;
    }

    private function handleMouseUp(event:MouseEvent):void {
        this.active.value = false;
    }

    private function handleVertexChange(event:Event):void {
        const vertex:IVertex = event.target as IVertex;
        this.configure(vertex);
    }

    private function handleLayoutChange(event:Event):void {
        this.configure(this.vertex);
    }

    private var controllers:Object = {};

    public function addController(c:*, name:String):void {
        this.controllers[name] = c;
    }

    public function getController(name:String):* {
        return this.controllers[name];
    }

    public function clone():IVertex {
        return new VertexView(_vertex.clone(), _layout, _icon);
    }
}
}