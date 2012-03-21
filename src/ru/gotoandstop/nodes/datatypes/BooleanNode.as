/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/20/12
 * Time: 11:39 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import com.bit101.components.CheckBox;
import com.bit101.components.IndicatorLight;
import com.bit101.components.Panel;
import com.bit101.components.PushButton;

import flash.display.DisplayObject;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.core.Node;
import ru.gotoandstop.nodes.core.SimpleNodeObject;

public class BooleanNode extends Node {
    private var contol:CheckBox;

    public function BooleanNode(object:ValueObject, vacuum:VacuumLayout) {
        super(vacuum, object);
        object.addEventListener(Event.CHANGE, handleChange);
        handleChange(null);
    }

    public override function getMarkers():Vector.<Object> {
        var result:Vector.<Object> = super.getMarkers();
        result.push({param:'value', x:80, y:10, dir:'right', type:'out'});
        return result;
    }

    override protected function draw():void {
        var s:Shape = new Shape();
        s.graphics.beginFill(0, 1);
        s.graphics.drawRect(0, 0, 80, 20);
        s.graphics.endFill();
        super.addChild(s);
        super._selectedShape = s;

        var h:Panel = new Panel();
        h.shadow = false;
        h.width = 80;
        h.height = 20;
        super.addChild(h);

        contol = new CheckBox();
        contol.addEventListener(MouseEvent.MOUSE_UP, handleControlMouseUp);
        contol.addEventListener(MouseEvent.CLICK, handleControlClick);
        contol.x = 5;
        contol.y = 5;
        contol.label = 'true or false';
        super.addChild(contol);

        var s2:Sprite = new Sprite();
        s2.x = 20;
        s2.graphics.beginFill(0, 0);
        s2.graphics.drawRect(0, 0, 60, 20);
        s2.graphics.endFill();
        super.addChild(s2);
        super.setDragTarget(s2);
    }

    private function handleChange(event:Event):void {
        contol.selected = super.model.getKeyValue('value').getValue();
    }

    private function handleControlClick(event:Event):void {
        super.model.setKeyValue('value', contol.selected);
    }

    private function handleControlMouseUp(event:MouseEvent):void {
        event.stopImmediatePropagation();
    }

    override public function dispose():void {
        super.model.removeEventListener(Event.CHANGE, handleChange);
        contol.removeEventListener(MouseEvent.MOUSE_UP, handleControlMouseUp);
        contol.removeEventListener(MouseEvent.CLICK, handleControlClick);
        super.dispose();
    }
}
}
