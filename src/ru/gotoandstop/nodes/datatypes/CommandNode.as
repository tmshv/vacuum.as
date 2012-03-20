/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/7/12
 * Time: 5:35 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import com.bit101.components.Label;
import com.bit101.components.Panel;

import flash.display.Shape;

import ru.gotoandstop.nodes.core.Node;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.datatypes.CommandObject;

public class CommandNode extends Node{
	public function CommandNode(model:CommandObject, vacuum:VacuumLayout) {
		super(vacuum, model);
	}

    override protected function draw():void {
        var s:Shape = new Shape();
        s.graphics.beginFill(0, 1);
        s.graphics.drawRect(0, 0, 150, 30);
        s.graphics.endFill();
        super.addChild(s);
        super._selectedShape = s;

        var h:Panel = new Panel();
        h.shadow = false;
        h.width = 150;
        h.height = 30;
        super.addChild(h);

        var label:Label;
        label = new Label(null, 10, 5, super.model.getKeyValue('description'));
        super.addChild(label);
    }

    public override function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = new Vector.<Object>;
		result.push({param:'init', x:0, y:15, dir:'left', type:'in'});
		return result;
	}
}
}
