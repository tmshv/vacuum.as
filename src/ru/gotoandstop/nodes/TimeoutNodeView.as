/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/1/12
 * Time: 5:50 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes {
import com.bit101.components.Label;
import com.bit101.components.Panel;

import ru.gotoandstop.nodes.NodeView;

public class TimeoutNodeView extends NodeView{
	private var _model:TimeoutNode;

	public function TimeoutNodeView(model:TimeoutNode, vacuum:VacuumLayout, vo:NodeVO) {
		super(vacuum, vo);
		_model = model;

		var p:Panel = new Panel();
		p.height = 50;
		super.addChild(p);
		
		var label:Label;
		label = new Label(null, 30, 0, 'timeout');
		p.addChild(label);

		label = new Label(null, 40, 30, 'delay');
		p.addChild(label);
	}

	public override function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = new Vector.<Object>;
		result.push({param:'init', x:0, y:25, dir:'left', type:'in'});
		result.push({param:'delay', x:50, y:50, dir:'top', type:'in'});
		result.push({param:'cmd', x:100, y:25, dir:'right', type:'out'});
		return result;
	}
}
}
