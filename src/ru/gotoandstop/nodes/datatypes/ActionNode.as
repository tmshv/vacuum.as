/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/15/12
 * Time: 2:40 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import com.bit101.components.Label;
import com.bit101.components.Panel;

import flash.display.Shape;

import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.core.Node;

public class ActionNode extends Node {
    protected var label:Label = new Label();
    public function ActionNode(model:ActionObject, vacuum:VacuumLayout) {
        super(vacuum, model);
        label.text = model.getKeyValue('description');
        label.x = 5;
        label.y = 10;
        super.rightBottom.setCoord(60, 30);
    }

    override protected function draw():void {
        var s:Shape = new Shape();
        s.graphics.beginFill(0, 1);
        s.graphics.drawRect(0, 0, 60, 30);
        s.graphics.endFill();
        super.addChild(s);
        super._selectedShape = s;

        var h:Panel = new Panel();
        h.color = 0xf5f5f5;
        h.shadow = false;
        h.width = 60;
        h.height = 30;
        super.addChild(h);

        super.addChild(label);
    }

    public override function getMarkers():Vector.<Object> {
        var result:Vector.<Object> = new Vector.<Object>;
        result.push({param:'init', dir:'left', type:'in', position:{x:"-3 left", y:"15 top"}});
        result.push({param:'done', dir:'right', type:'out', position:{x:"3 right", y:"15 top"}});
        return result;
    }
}
}
