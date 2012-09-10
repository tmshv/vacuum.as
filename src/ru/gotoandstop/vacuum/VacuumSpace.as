/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/23/12
 * Time: 10:09 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.vacuum {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.render.DisplayVertex;
import ru.gotoandstop.vacuum.render.DisplayVertex;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.IVertex;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.LayoutVertex;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.splines.RectSpline;
import ru.gotoandstop.vacuum.view.VertexIcon;
import ru.gotoandstop.vacuum.view.VertexIcon;
import ru.gotoandstop.vacuum.view.VertexView;

public class VacuumSpace extends Sprite implements IDisposable{
    public var defaultIcon:VertexIcon;

    private var _layout:Layout;
    public function get layout():Layout {
        return _layout;
    }

    private var _mouseDown:Point;
    
    private var selector:RectSpline;
    
    public function VacuumSpace() {
        _layout = new Layout();
        super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    public function showVertex(vertex:IVertex, icon:VertexIcon=null):IVertex{
        var view:VertexView;
        if(vertex is VertexView) {
            super.addChild(vertex as VertexView);
        }else{
            view = new VertexView(vertex, _layout, icon);
            super.addChild(view);
        }
        return view;
    }

    private function handleAddedToStage(event:Event):void{
        super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        super.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        super.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
        super.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);

        selector = new RectSpline(super.stage, true);
        selector.closed = true;
        super.addChild(new SplineView(selector));
    }

    private function handleMouseDown(event:MouseEvent):void{
        var under:DisplayObject = event.target as DisplayObject;
        if(!(event.currentTarget as DisplayObjectContainer).contains(under)) {
            _mouseDown = new Point(event.stageX, event.stageY);
        }
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

    public function createVertex(x:Number, y:Number, icon:VertexIcon=null, mouseInteraction:Boolean=false):Object {
        var v_base:IVertex = new Vertex(x, y);
        var v_layout:LayoutVertex = new LayoutVertex(v_base);
        v_layout.setLayout(_layout);
        var v_disp:DisplayVertex = new DisplayVertex(v_layout, icon ? icon : defaultIcon);
        addChild(v_disp);

        return {
            base:v_base,
            layout:v_layout,
            display:v_disp
        };
    }

    public function createScreenVertex(x:Number, y:Number, icon:VertexIcon=null, mouseInteraction:Boolean=false):Object{
        return createVertex(x, y, icon, mouseInteraction);
    }
}
}
