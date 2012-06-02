package ru.gotoandstop.vacuum.core {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;

import ru.gotoandstop.ILockable;

[Event(name="change", type="flash.events.Event")]

/**
 *
 * Creation date: May 1, 2011 (1:28:18 AM)
 * @author Roman Timashev (roman@tmshv.ru)
 */
public class Vertex extends EventDispatcher implements IVertex, ILockable {
    private var _x:Number;
    public function get x():Number {
        return _x;
    }

    public function set x(value:Number):void {
        _x = value;
        changed = true;
        update();
    }

    private var _y:Number;
    public function get y():Number {
        return _y;
    }

    public function set y(value:Number):void {
        _y = value;
        changed = true;
        update();
    }

    protected var changed:Boolean;
    private var _locked:Boolean;

    public function get isLocked():Boolean {
        return _locked;
    }

    public function Vertex(x:Number = 0, y:Number = 0) {
        setCoord(x, y);
    }

    public function clone():IVertex {
        return new Vertex(x, y);
    }

    public function setCoord(x:Number, y:Number):void {
        lock();
        this.x = x;
        this.y = y;
        unlock();
    }

    public function getCoord(params:Object = null):Point {
        return new Point(x, y);
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

    public function onChange(listener:Function, useWeakReference:Boolean = false):void {
        super.addEventListener(Event.CHANGE, listener, false, 0, useWeakReference);
    }

    public function offChange(listener:Function):void {
        super.removeEventListener(Event.CHANGE, listener);
    }

    public override function toString():String {
        return toPoint().toString();
    }

    public function toPoint():Point {
        return new Point(x, y);
    }
}
}