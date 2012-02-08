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

import ru.gotoandstop.nodes.NodeView;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.datatypes.CommandObject;

public class CommandNode extends NodeView{
	public function CommandNode(model:CommandObject, vacuum:VacuumLayout) {
		super(vacuum);
		super._model = model;

		var h:Panel = new Panel();
		h.width = 150;
		h.height = 30;
		super.addChild(h);

		var label:Label;
		label = new Label(null, 10, 5, model.description);
		super.addChild(label);

		super.createPoints(getMarkers());
	}

	public override function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = new Vector.<Object>;
		result.push({param:'init', x:0, y:15, dir:'left', type:'in'});
		return result;
	}
}
}
