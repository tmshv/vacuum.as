/**
 *
 * User: tmshv
 * Date: 5/24/12
 * Time: 10:26 PM
 */
package ru.gotoandstop.nodes.proxies {
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.geom.Point;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.controllers.MouseController;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.view.CircleIcon;
import ru.gotoandstop.vacuum.view.RectIcon;
import ru.gotoandstop.vacuum.view.VertexIcon;
import ru.gotoandstop.vacuum.view.VertexView;

public class MouseCoordPicker implements IDisposable {
    private var picker:VertexView;
    private var pickerMover:MouseController;
    private var _listenObject:Boolean;
    private var _node:INode;
    private var _vertexContainer:DisplayObjectContainer;

    public function MouseCoordPicker(node:INode, vertexContainer:DisplayObjectContainer) {
        _vertexContainer = vertexContainer;
        _node = node;
        _node.addEventListener(Event.CHANGE, handleObjectChange);
//        picker = new VertexView(new Vertex(), new Layout(), new CircleIcon(0xffffffff, 0x44000000, 8));
        var icon:VertexIcon = new RectIcon(0xffffffff, 0x99000000, 8);
        icon.rotation = 45;
        picker = new VertexView(new Vertex(), new Layout(), icon);
        picker.vertex.addEventListener(Event.CHANGE, handlePickerChange);
        pickerMover = new MouseController(picker);
        pickerMover.useGlobalOffset = false;
        vertexContainer.addChild(picker);
        startListenObject();
        placeOnScreen();
    }

    public function dispose():void {
        _vertexContainer.removeChild(picker);
        _node.removeEventListener(Event.CHANGE, handleObjectChange);
        picker.vertex.removeEventListener(Event.CHANGE, handlePickerChange);
        _node = null;
        picker = null;
        _vertexContainer = null;
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
