/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/24/12
 * Time: 12:02 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes {
import com.bit101.components.Panel;

import flash.events.Event;

import flash.events.MouseEvent;
import flash.geom.Point;

import ru.gotoandstop.nodes.core.NodeChangeEvent;

import ru.gotoandstop.nodes.datatypes.ActionNode;
import ru.gotoandstop.nodes.datatypes.ActionObject;

public class ResizebleNode extends ActionNode {
    private var _panel:Panel;
    private var _localMouseDown:Point;
    private var _localMouseDownRightBottom:Point;
    private var _resizeMode:Boolean;
    
    private var _currentWidth:uint;
    private var _currentHeight:uint;

    public function ResizebleNode(object:ActionObject, vacuum:VacuumLayout) {
        super(object, vacuum);

        handleChange(null);
        super.object.addEventListener(Event.CHANGE, handleChange);
        super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    override protected function draw():void {
        _panel = new Panel();
        _panel.shadow = false;
        super.addChild(_panel);

        super._selectedShape = _panel;
    }

    private function handleChange(event:NodeChangeEvent):void {
        var w:uint = super.object.get('width');
        var h:uint = super.object.get('height');
        super.rightBottom.setCoord(w, h);
        _panel.width = w;
        _panel.height = h;
        _currentWidth = w;
        _currentHeight = h;
    }

    private function handleMouseDown(event:MouseEvent):void {
        var w:uint = _panel.width;//super.model.getKeyValue('width');
        var h:uint = _panel.height;//super.model.getKeyValue('height');
        var dx:int = w - event.localX;
        var dy:int = h - event.localY;
        if (dx < 15 && dy < 15) {
            event.stopImmediatePropagation();
            _resizeMode = true;
        }

        _localMouseDown = new Point(event.localX, event.localY);
        _localMouseDownRightBottom = new Point(w - _localMouseDown.x, h - _localMouseDown.y);
    }

    private function handleMouseMove(event:MouseEvent):void {
        if (_localMouseDown && _resizeMode) {
            var w:uint = event.stageX - super.x;
            var h:uint = event.stageY - super.y;
            w += _localMouseDownRightBottom.x;
            h += _localMouseDownRightBottom.y;
            if (w > 30 && h > 30) {
                super.object.set('width', w);
                super.object.set('height', h);
            }
            event.stopImmediatePropagation();
        }
    }

    private function handleMouseUp(event:MouseEvent):void {
        _localMouseDown = null;
        _resizeMode = false;
    }

    private function handleAddedToStage(event:Event):void {
        super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        super.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        super.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, true);
        super.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
    }

    override public function dispose():void {
        super.object.removeEventListener(Event.CHANGE, handleChange);
        super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        super.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        super.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, true);
        super.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
        super.dispose();
    }
}
}
