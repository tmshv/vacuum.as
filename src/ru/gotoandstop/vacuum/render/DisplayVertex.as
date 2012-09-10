/**
 * Created with IntelliJ IDEA.
 * User: tmshv
 * Date: 5/26/12
 * Time: 4:40 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.vacuum.render {
import ru.gotoandstop.vacuum.core.*;

import flash.display.Sprite;
import flash.events.Event;

import ru.gotoandstop.IDisposable;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.view.RectIcon;
import ru.gotoandstop.vacuum.view.VertexIcon;

public class DisplayVertex extends Sprite implements IDisposable{
    public static var defaultIcon:VertexIcon = new RectIcon(0, 0xff000000, 3);

    private var _vertex:IVertex;

    public function DisplayVertex(vertex:IVertex, icon:VertexIcon=null) {
        super();
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
}
}
