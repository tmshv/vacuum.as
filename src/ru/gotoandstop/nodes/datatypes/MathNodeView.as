package ru.gotoandstop.nodes.datatypes {
import ru.gotoandstop.nodes.*;

import com.bit101.components.Text;

import ru.gotoandstop.nodes.core.Node;

/**
	 *
	 * creation date: Jan 26, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class MathNodeView extends Node {
		public function MathNodeView(model:MathNode, vacuum:VacuumLayout, vo:NodeVO) {
			super(vacuum, vo);
			
			super._model = model;
			
			var text:Text = new Text();
			text.width = 60;
			text.height = 24;
			text.editable = false;
			text.selectable = false;
			text.text = '  A + B = C';
			super.addChild(text);
		}
		
		public override function getMarkers():Vector.<Object> {
			var result:Vector.<Object> = new Vector.<Object>;
			result.push({param: 'first', x: 0, y: 10, dir: 'left', type: 'in'});
			result.push({param: 'second', x: 30, y: 0, dir: 'up', type: 'in'});
			result.push({param: 'value', x: 60, y: 10, dir: 'right', type: 'out'});
			return result;
		}
	}
}