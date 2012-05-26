package ru.gotoandstop.vacuum.controllers {
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.view.VertexView;

/**
 *
 * Creation date: May 2, 2011 (3:04:51 AM)
 * @author Roman Timashev (roman@tmshv.ru)
 */
public class MouseController extends EventDispatcher implements IDisposable {
    private var _dot:VertexView;
    private var _target:DisplayObject;
    private var _mouseDown:Boolean;

    private var _mouseOffset:Point;

    public function MouseController(dot:VertexView, target:DisplayObject = null) {
        super();
        _dot = dot;
        if (target) {
            _target = target;
        } else {
            _target = dot;
        }
        setTarget(_target);
    }

    private function handleAddedToStage(event:Event):void {
        _target.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        setTarget(_target);
    }

    public function setTarget(target:DisplayObject):void {
        if (_target && _target.stage) {
            _target.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
            _target.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            _target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        }

        _target = target;
        if (_target.stage) {
            _target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
            _target.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            _target.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        } else {
            _target.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        }
    }

    public function dispose():void {
        if (_target) {
            _target.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }

        if (_target.stage) {
            _target.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            _target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        }

        _target = null;
        _dot = null;
    }

    public function startMove():void {
        this._mouseDown = true;
        //			this.dot.active.value = true;
        this._mouseOffset = new Point(-this._dot.mouseX, -this._dot.mouseY);
    }

    public function stopMove():void {
        this._mouseDown = false;
        //			this.dot.active.value = false;
    }

    /**
     * Если мышь нажата, менять модель
     * @param event
     *
     */
    private function handleMouseMove(event:MouseEvent):void {
        if (_mouseDown) {
            var coord:Point = VertexView.screenToLayout(
                    _dot,
                    event.stageX + _mouseOffset.x,
                    event.stageY + _mouseOffset.y
            );

            var c:Boolean = _dot.considerScaleLayout;
            _dot.considerScaleLayout = true;
            _dot.vertex.setCoord(
                    coord.x,
                    coord.y
            );
            _dot.considerScaleLayout = c;
        }
    }

    /**
     * При нажатии на вьюшку она активирутся.
     * @param event
     *
     */
    private function handleMouseDown(event:MouseEvent):void {
        this.startMove();
    }

    private function handleMouseUp(event:MouseEvent):void {
        this.stopMove();
    }
}
}