/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/8/12
 * Time: 7:37 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import com.bit101.components.Label;
import com.bit101.components.Panel;

import ru.gotoandstop.nodes.core.Node;
import ru.gotoandstop.nodes.VacuumLayout;

public class InitNode extends Node{
	public function InitNode(model:InitObject, vacuum:VacuumLayout) {
		super(vacuum, model);

		var h:Panel = new Panel();
		h.color = 0xF5B0AB;
		h.width = 50;
		h.height = 20;
		super.addChild(h);

		super.addChild(new Label(null, 12, 0, 'init();'));
		
		super.createPoints(getMarkers());
	}

	public override function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = new Vector.<Object>;
		result.push({param:'done', x:50, y:10, dir:'right', type:'out'});
		return result;
	}
}
}
