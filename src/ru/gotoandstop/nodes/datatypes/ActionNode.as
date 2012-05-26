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
    public function ActionNode(object:ActionObject, vacuum:VacuumLayout) {
        super(object, vacuum);

        var complex:Object;
        complex = Node.getComplexifiedObject(object.get("init"));
        complex.access = "write";
        complex.display = "%key";
        super.updateField("init", complex);

        complex = Node.getComplexifiedObject(object.get("done"));
        complex.access = "read";
        complex.display = "%key";
        super.updateField("done", complex);
    }
}
}
