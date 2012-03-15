/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/1/12
 * Time: 5:50 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import ru.gotoandstop.nodes.*;

import com.bit101.components.Label;
import com.bit101.components.Panel;

import ru.gotoandstop.nodes.core.Node;

public class TimeoutNode extends Node{
	private var timeout:TimeoutObject;

	public function TimeoutNode(model:TimeoutObject, vacuum:VacuumLayout) {
		super(vacuum, model);
		timeout = model;

		var p:Panel = new Panel();
		p.height = 50;
		super.addChild(p);
		
		var label:Label;
		label = new Label(null, 30, 0, 'timeout');
		p.addChild(label);

		label = new Label(null, 40, 30, 'delay');
		p.addChild(label);

		super.createPoints(getMarkers());
	}

	public override function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = new Vector.<Object>;
		result.push({param:'init', x:0, y:25, dir:'left', type:'in'});
		result.push({param:'delay', x:50, y:50, dir:'down', type:'in'});
		result.push({param:'done', x:100, y:25, dir:'right', type:'out'});
		return result;
	}
}
}
