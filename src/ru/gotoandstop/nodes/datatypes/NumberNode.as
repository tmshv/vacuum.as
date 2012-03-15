package ru.gotoandstop.nodes.datatypes {
import com.bit101.components.NumericStepper;
import com.bit101.components.Panel;

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

		var h:Panel = new Panel();
		h.height = 35;
		super.addChild(h);
		super.setDragTarget(h);

		num = new NumericStepper(null, 10, 10, handleNumeric);
		super.addChild(num);

		model.addEventListener(Event.CHANGE, handleChange);
		num.value = model.getValue();
		currentValue = num.value;

		super.createPoints(getMarkers());
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
		var result:Vector.<Object> = new Vector.<Object>;
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
}
}
