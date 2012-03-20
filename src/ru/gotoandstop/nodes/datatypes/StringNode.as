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

import flash.display.Shape;

import flash.events.Event;

import ru.gotoandstop.nodes.core.Node;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.core.NodeChangeEvent;

public class StringNode extends Node {
	private var text:Text;

	public function StringNode(model:StringObject, vacuum:VacuumLayout) {
		super(vacuum, model);
		model.addEventListener(Event.CHANGE, handleChange);
	}

	public override function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = new Vector.<Object>;
		result.push({param:'value', x:170, y:20, dir:'right', type:'out'});
		return result;
	}

    override protected function draw():void {
        var s:Shape = new Shape();
        s.graphics.beginFill(0, 1);
        s.graphics.drawRect(0, 0, 170, 40);
        s.graphics.endFill();
        super.addChild(s);
        super._selectedShape = s;

        var h:Panel = new Panel();
        h.shadow = false;
        h.width = 170;
        h.height = 40;
        super.addChild(h);
        super.setDragTarget(h);

        text = new Text();
        text.addEventListener(Event.CHANGE, handleTextChange);
        text.x = 10;
        text.y = 10;
        text.width = 150;
        text.height = 20;
        text.text = super._model.getKeyValue('value').value;
        super.addChild(text);
    }

    private function handleTextChange(event:Event):void {
        super.model.setKeyValue('value', text.text);
    }
    
	private function handleChange(event:NodeChangeEvent):void {
		if (event.key == 'value' && event.value != text.text) {
            text.text = event.value;
		}
	}

    override public function dispose():void {
        text.removeEventListener(Event.CHANGE, handleTextChange);
        super.dispose();
    }
}
}
