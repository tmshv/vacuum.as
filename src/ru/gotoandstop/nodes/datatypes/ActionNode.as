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

import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.core.Node;

public class ActionNode extends Node{
    public function ActionNode(model:ActionObject, vacuum:VacuumLayout) {
        super(vacuum, model);
        draw();
        super.createPoints(getMarkers());
    }

    protected function draw():void{
        var h:Panel = new Panel();
        h.width = 100;
        h.height = 30;
        super.addChild(h);

//        var label:Label;
//        label = new Label(null, 10, 5, model.description);
//        super.addChild(label);
    }

    public override function getMarkers():Vector.<Object> {
        var result:Vector.<Object> = new Vector.<Object>;
        result.push({param:'init', x:0, y:15, dir:'left', type:'in'});
        result.push({param:'done', x:100, y:15, dir:'right', type:'out'});
        return result;
    }
}
}
