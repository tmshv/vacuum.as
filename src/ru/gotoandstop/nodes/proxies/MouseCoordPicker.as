/**
 *
 * User: tmshv
 * Date: 5/24/12
 * Time: 10:26 PM
 */
package ru.gotoandstop.nodes.proxies {
import flash.events.Event;
import flash.geom.Point;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.vacuum.controllers.MouseController;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.view.CircleIcon;
import ru.gotoandstop.vacuum.view.VertexView;

public class MouseCoordPicker implements IDisposable {
    private var picker:VertexView;
    private var pickerMover:MouseController;
    private var _listenObject:Boolean;
    private var _node:INode;
    private var _vacuum:VacuumLayout;

    public function MouseCoordPicker(node:INode, vacuum:VacuumLayout) {
        _vacuum = vacuum;
        _node = node;
        _node.addEventListener(Event.CHANGE, handleObjectChange);
        picker = new VertexView(new Vertex(), vacuum.layout, new CircleIcon(0xffffff00, 0x44000000, 16));
        picker.vertex.addEventListener(Event.CHANGE, handlePickerChange);
        pickerMover = new MouseController(picker);
        vacuum.showVertex(picker);
        startListenObject();
        placeOnScreen();
    }

    public function dispose():void {
        _vacuum.hideVertex(picker);
        _node.removeEventListener(Event.CHANGE, handleObjectChange);
        picker.vertex.removeEventListener(Event.CHANGE, handlePickerChange);
        _node = null;
        picker = null;
        pickerMover.dispose();
    }

    private function startListenObject():void {
        _listenObject = true;
//        placeOnScreen();
    }

    private function stopListenObject():void {
        _listenObject = false;
    }

    private function placeOnScreen():void {
        var x:Number = _node.get("x");
        var y:Number = _node.get("y");

        var pos:Point = picker.screenCoordToIdeal(x, y);

//        x = (x) - _vacuum.layout.center.x);// * _vacuum.layout.scale.value;
//        y = (y - _vacuum.layout.center.y);// * _vacuum.layout.scale.value;
        picker.setCoord(pos.x, pos.y);
    }

    private function handleObjectChange(event:Event):void {
        if (!_listenObject)  return;
        const change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            placeOnScreen();
        }
    }

    private function handlePickerChange(event:Event):void {
        var screen:Point = picker.localToGlobal(new Point());
        stopListenObject();
        _node.set('x', screen.x);
        _node.set('y', screen.y);
        startListenObject();
    }
}
}
