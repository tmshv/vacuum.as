/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 06.02.12
 * Time: 0:13
 *
 */
package ru.gotoandstop.nodes.datatypes {
import com.bit101.components.Panel;
import com.bit101.components.Text;

import flash.events.Event;

import ru.gotoandstop.nodes.core.Node;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.core.NodeEvent;

public class StringNode extends Node {
	private var text:Text;

	public function StringNode(model:StringObject, vacuum:VacuumLayout) {
		super(vacuum);
		super._model = model;

		model.addEventListener(Event.CHANGE, handleChange);

		var h:Panel = new Panel();
		h.width = 170;
		h.height = 40;
		super.addChild(h);
		super.setDragTarget(h);

		text = new Text();
		text.x = 10;
		text.y = 10;
		text.width = 150;
		text.height = 20;
		//		text.editable = false;
		//		text.selectable = false;
		text.text = model.getValue();
		super.addChild(text);

		super.createPoints(getMarkers());
	}

	public override function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = new Vector.<Object>;
		result.push({param:'value', x:170, y:20, dir:'right', type:'out'});
		return result;
	}

	private function handleChange(event:NodeEvent):void {
		if (event.key == 'value') {
			text.text = event.value;
		}
	}
}
}
