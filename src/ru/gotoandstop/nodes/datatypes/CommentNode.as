/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/7/12
 * Time: 4:32 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import com.bit101.components.Panel;
import com.bit101.components.Text;

import flash.events.Event;

import ru.gotoandstop.nodes.NodeView;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.core.NodeEvent;

public class CommentNode extends NodeView {
	private var text:Text;
	private var string:StringObject;

	public function CommentNode(model:StringObject, vacuum:VacuumLayout) {
		super(vacuum);
		super._model = model;
		super._model.addEventListener(Event.CHANGE, handleStringChange);
		string = model;

		var h:Panel = new Panel();
		h.width = 150;
		h.height = 150;
		super.addChild(h);
		super.setDragTarget(h);

		text = new Text();
		text.addEventListener(Event.CHANGE, handleTextChange);
		text.editable = true;
		text.selectable = true;
		text.x = 10;
		text.y = 10;
		text.width = 130;
		text.height = 130;
		super.addChild(text);

		writeText();
	}

	private function writeText(comment:String = null):void {
		var txt:String = comment ? comment : string.getValue();
		text.text = txt;
	}

	private function handleStringChange(event:NodeEvent):void {
		if (text.text != event.value) writeText(event.value);
	}

	private function handleTextChange(event:Event):void {
		string.setValue(text.text);
	}

	override public function getParams():Vector.<String> {
		var params:Vector.<String> = new Vector.<String>();
		params.push('value');
		return params;
	}
}
}
