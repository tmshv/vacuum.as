/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/1/12
 * Time: 5:50 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import flash.display.Shape;

import ru.gotoandstop.command.MacroCommand;
import ru.gotoandstop.nodes.*;

import com.bit101.components.Label;
import com.bit101.components.Panel;

import ru.gotoandstop.nodes.commands.ShakeCommand;
import ru.gotoandstop.nodes.commands.TimeoutCommand;

import ru.gotoandstop.nodes.core.Node;
import ru.gotoandstop.nodes.datatypes.ActionNode;

public class TimeoutNode extends ActionNode{
	private var timeout:TimeoutObject;

	public function TimeoutNode(model:TimeoutObject, vacuum:VacuumLayout) {
        timeout = model;
        super(model, vacuum);
        super.rightBottom.setCoord(100, 50);

//        var overrided:MacroCommand = new MacroCommand();
//        overrided.addCommand(new ShakeCommand(this, 2, 0.3));
//        overrided.addCommand(new TimeoutCommand(400, model.getKeyValue('done')));
//        model.overrideAction(overrided);
    }

    override protected function draw():void {
        var s:Shape = new Shape();
        s.graphics.beginFill(0, 1);
        s.graphics.drawRect(0, 0, 100, 50);
        s.graphics.endFill();
        super.addChild(s);
        super._selectedShape = s;

        var p:Panel = new Panel();
        p.shadow = false;
        p.height = 50;
        super.addChild(p);

        var label:Label;
        label = new Label(null, 30, 0, 'timeout');
        p.addChild(label);

        label = new Label(null, 40, 30, 'delay');
        p.addChild(label);
    }
}
}
