package ru.gotoandstop.nodes.datatypes {
import com.bit101.components.NumericStepper;
import com.bit101.components.Panel;

import flash.display.Shape;

import flash.events.Event;

import ru.gotoandstop.nodes.*;
import ru.gotoandstop.nodes.core.Node;
import ru.gotoandstop.nodes.core.NodeEvent;

/**
 * @author tmshv
 */
public class NumberNode extends Node {
	private var currentValue:Number;
	private var num:NumericStepper;

	public function NumberNode(model:NumberObject, vacuum:VacuumLayout) {
		super(vacuum, model);

		model.addEventListener(Event.CHANGE, handleChange);
		num.value = model.getValue();
		currentValue = num.value;
	}

	public override function dispose():void {
		num.removeEventListener(Event.CHANGE, handleNumeric);
		super._model.getKeyValue('value').removeEventListener(Event.CHANGE, handleChange);
		num = null;

		super.dispose();
	}

	private function handleNumeric(event:Event):void {
		var num:NumericStepper = event.target as NumericStepper;
		currentValue = num.value;
		super._model.setKeyValue('value', currentValue);
	}

	public override function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = super.getMarkers();
		result.push({param:'value', x:100, y:35 / 2, dir:'right', type:'out'});
		return result;
	}

	private function handleChange(event:NodeEvent):void {
		if (event.key == 'value') {
			if (currentValue != event.value) {
				num.value = event.value;
				currentValue = event.value;
			}
		}
	}

    override protected function draw():void {
        var s:Shape = new Shape();
        s.graphics.beginFill(0, 1);
        s.graphics.drawRect(0, 0, 100, 35);
        s.graphics.endFill();
        super.addChild(s);
        super._selectedShape = s;

        var h:Panel = new Panel();
        h.shadow = false;
        h.height = 35;
        super.addChild(h);
        super.setDragTarget(h);

        num = new NumericStepper(null, 10, 10, handleNumeric);
        super.addChild(num);
    }
}
}
