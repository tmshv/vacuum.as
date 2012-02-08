package ru.gotoandstop.nodes.datatypes {
import ru.gotoandstop.nodes.*;

import com.bit101.components.Label;
import com.bit101.components.Panel;

/**
 *
 * creation date: Jan 27, 2012
 * @author Roman Timashev (roman@tmshv.ru)
 **/
public class IfNodeView extends NodeView {
	//		private var clip:IfNodeClip;

	public function IfNodeView(model:IfNode, vacuum:VacuumLayout, vo:NodeVO) {
		super(vacuum, vo);
		super._model = model;

		var panel:Panel = new Panel();
		panel.width = 60;
		panel.height = 40;
		super.addChild(panel);

		var label:Label;
		label = new Label(null, 30, 00, 'then');
		super.addChild(label);

		label = new Label(null, 30, 20, 'else');
		super.addChild(label);

		label = new Label(null, 10, 10, 'if');
		super.addChild(label);

		//			this.clip = new IfNodeClip();
		//			super.addChild(this.clip);
	}

	public override function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = new Vector.<Object>;
		result.push({param:'boolean', x:0, y:20, dir:'left', type:'in'});
		result.push({param:'then', x:60, y:10, dir:'right', type:'out'});
		result.push({param:'else', x:60, y:30, dir:'right', type:'out'});
		return result;
	}
}
}