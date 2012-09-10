package ru.gotoandstop.vacuum {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Point;

import ru.gotoandstop.IDisposable;

import ru.gotoandstop.ILockable;

import ru.gotoandstop.geom.Vector2D;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.values.IntValue;
import ru.gotoandstop.values.NumberValue;

[Event(name="change", type="flash.events.Event")]

/**
 *
 * Creation date: May 2, 2011 (12:41:46 PM)
 * @author Roman Timashev (roman@tmshv.ru)
 *
 */
public class Layout extends EventDispatcher implements IDisposable, ILockable {
    private var _scale:NumberValue;
    public function get scale():NumberValue {
        return this._scale;
    }

    private var _rotation:NumberValue;
    public function get rotation():NumberValue {
        return this._rotation;
    }

    private var _center:Vertex;
    public function get center():Vertex {
        return this._center;
    }

    private var _directionX:IntValue;
    public function get directionX():IntValue {
        return this._directionX;
    }

    private var _directionY:IntValue;
    public function get directionY():IntValue {
        return this._directionY;
    }

    private var changed:Boolean;
    private var _locked:Boolean;

    public function get isLocked():Boolean {
        return this._locked;
    }

    public function Layout() {
        super();
        _scale = new NumberValue(1);
        _rotation = new NumberValue(0);
        _center = new Vertex();
        _directionX = new DirectionValue();
        _directionY = new DirectionValue();

        rotation.addEventListener(Event.CHANGE, handleChange);
        scale.addEventListener(Event.CHANGE, handleChange);
        center.addEventListener(Event.CHANGE, handleChange);
    }

    public function screenToLayout(screenCoord:Point):Point{
        var m:Matrix = new Matrix();
        m.rotate(_rotation.value);
        m.scale(_scale.value, _scale.value);
        m.translate(_center.x, _center.y);
        return m.transformPoint(screenCoord);
    }

    public function dispose():void {
        rotation.removeEventListener(Event.CHANGE, handleChange);
        scale.removeEventListener(Event.CHANGE, handleChange);
        center.removeEventListener(Event.CHANGE, handleChange);
    }

    public function configure(scale:Number = 1, x:Number = 0, y:Number = 0, rotation:Number = 0):void {
        lock();
        this.scale.value = scale;
        this.rotation.value = rotation;
        center.setCoord(x, y);
        unlock();
    }

    public function lock():void {
        _locked = true;
    }

    public function unlock():void {
        _locked = false;
        if (changed) {
            update();
        }
    }

    public function update():void {
        if (!isLocked) {
            super.dispatchEvent(new Event(Event.CHANGE));
            changed = false;
        }
    }

    private function handleChange(event:Event):void {
        changed = true;
        update();
    }
}
}

import ru.gotoandstop.values.IntValue;

internal class DirectionValue extends IntValue {
    public override function set value(value:int):void {
        value = value < 0 ? -1 : 1;
        super.value = value;
    }

    public function DirectionValue(value:int = 1) {

    }
}