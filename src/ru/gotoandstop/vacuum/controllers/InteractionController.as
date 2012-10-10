package ru.gotoandstop.vacuum.controllers {
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.VacuumSpace;
import ru.gotoandstop.vacuum.render.DisplayVertex;
import ru.gotoandstop.vacuum.view.VertexView;

/**
 *
 * Creation date: May 2, 2011 (3:04:51 AM)
 * @author Roman Timashev (roman@tmshv.ru)
 */
public class InteractionController extends EventDispatcher implements IDisposable {
    private var _space:VacuumSpace;
    private var _vertex:DisplayVertex;
    private var _target:DisplayObject;

    private var _offset:Point;
    private var _moveMode:Boolean;

    public var invertLayout:Boolean = true;

    public function InteractionController(space:VacuumSpace, vertex:DisplayVertex, target:DisplayObject = null) {
        super();
        _space = space;
        _vertex = vertex;
        _target = vertex;
        if (target) _target = target;
        else _target = vertex;
        setTarget(_target);
    }

    private function handleAddedToStage(event:Event):void {
        _target.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        addListernersToTarget();
    }

    public function setTarget(target:DisplayObject):void {
        if (_target && _target.stage) {
            _target.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
            _target.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            _target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, interact);
        }

        _target = target;
        if (_target.stage) addListernersToTarget();
        else _target.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function addListernersToTarget():void {
        _target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        _target.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
        _target.stage.addEventListener(MouseEvent.MOUSE_MOVE, interact);
    }

    public function dispose():void {
        if (_target) {
            _target.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        }

        if (_target.stage) {
            _target.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
            _target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, interact);
        }

        _target = null;
        _vertex = null;
        _space = null;
    }

    public function startMove():void {
        _moveMode = true;
        _offset = new Point(-_target.mouseX, -_target.mouseY);
        _offset.offset(-_space.x, -_space.y);
    }

    public function stopMove():void {
        _moveMode = false;
    }

    /**
     * Если мышь нажата, менять модель
     * @param event
     *
     */
    private function interact(event:MouseEvent):void {
        if (_moveMode) {
            var coord:Point = _offset.clone();
            coord.offset(event.stageX, event.stageY);
//            if (invertLayout) coord = _space.layout.invertLayout(coord);
            _vertex.vertex.setCoord(coord.x, coord.y);
        }
    }

    /**
     * При нажатии на вьюшку она активирутся.
     * @param event
     *
     */
    private function handleMouseDown(event:MouseEvent):void {
        startMove();
    }

    private function handleMouseUp(event:MouseEvent):void {
        stopMove();
    }
}
}