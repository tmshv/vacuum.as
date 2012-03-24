/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/23/12
 * Time: 10:09 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.vacuum {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.gotoandstop.IDisposable;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.splines.RectSpline;
import ru.gotoandstop.vacuum.view.VertexIcon;
import ru.gotoandstop.vacuum.view.VertexView;

public class VacuumSpace extends Sprite implements IDisposable{
    private var _layout:Layout;
    public function get layout():Layout {
        return _layout;
    }

    private var _mouseDown:Point;
    
    private var selector:RectSpline;
    
    public function VacuumSpace() {
        _layout = new Layout();
        super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        selector = new RectSpline();
        selector.closed = true;
        super.addChild(new SplineView(selector));
    }

    public function showVertex(vertex:IVertex, icon:VertexIcon=null):void{
        if(icon) {
            super.addChild(new VertexView(vertex, _layout, icon));
        }
    }

    private function handleAddedToStage(event:Event):void{
        super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        super.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        super.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
        super.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
    }

    private function handleMouseDown(event:MouseEvent):void{
        _mouseDown = new Point(event.stageX, event.stageY);
    }

    private function handleMouseUp(event:Event):void{
        _mouseDown = null;
        selector.setLeft(0);
        selector.setTop(0);
        selector.setRight(0);
        selector.setBottom(0);
    }

    private function handleMouseMove(event:MouseEvent):void{
        if(_mouseDown) {
            selector.setLeft(_mouseDown.x);
            selector.setTop(_mouseDown.y);
            selector.setRight(event.stageX);
            selector.setBottom(event.stageY);
        }
    }
    
    public function dispose():void {
        super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        super.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        super.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
        super.stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
    }
}
}
