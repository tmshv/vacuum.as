/**
 * Created with IntelliJ IDEA.
 * User: tmshv
 * Date: 5/26/12
 * Time: 4:40 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.vacuum.render {
import flash.geom.Point;

import ru.gotoandstop.vacuum.VacuumSpace;
import ru.gotoandstop.vacuum.controllers.InteractionController;
import ru.gotoandstop.vacuum.controllers.MouseController;
import ru.gotoandstop.vacuum.core.*;

import flash.display.Sprite;
import flash.events.Event;

import ru.gotoandstop.IDisposable;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.view.RectIcon;
import ru.gotoandstop.vacuum.view.VertexIcon;

public class DisplayVertex extends Sprite implements IDisposable{
    public static var defaultIcon:VertexIcon = new RectIcon(0, 0xff000000, 3);

    private var _interactionController:InteractionController;

    private var _vertex:IVertex;
    public function get vertex():IVertex{
        return _vertex;
    }

    private var _space:VacuumSpace;
    public function get space():VacuumSpace{
        return _space;
    }

    public function DisplayVertex(space:VacuumSpace, vertex:IVertex, icon:VertexIcon=null) {
        super();
        _space = space;
        _vertex = vertex;
        _vertex.onChange(recalc);

        super.addChild(icon ? icon : defaultIcon);

        recalc();
    }

    protected function recalc(event:Event=null):void{
        super.x = _vertex.x;
        super.y = _vertex.y;
    }

    public function dispose():void {
        _vertex.offChange(recalc);
    }

    public function enableInteraction(inverseMatrixLayout:Boolean=true):void {
        _interactionController = new InteractionController(space, this);
        _interactionController.invertLayout = inverseMatrixLayout;
    }

    public function disableInteraction():void {
        if(_interactionController) {
            _interactionController.dispose();
            _interactionController = null;
        }
    }
}
}
