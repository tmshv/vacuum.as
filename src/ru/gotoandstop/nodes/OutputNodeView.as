package ru.gotoandstop.nodes {
import com.bit101.components.Text;

import flash.events.Event;

/**
	 *
	 * creation date: Jan 21, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class OutputNodeView extends NodeView {
		private var text:Text;
		
		public function OutputNodeView(model:OutputNode, vacuum:VacuumLayout, vo:NodeVO) {
			super(vacuum, vo);
			super.model = model;
			super.model.addEventListener(Event.CHANGE, this.handleChange);
			
			var t:Text = new Text();
			t.editable = false;
			t.selectable = false;
			t.width = 200;
			t.height = 150;
			super.addChild(t);
			this.text = t;
		}
		
		public override function dispose():void {
			super.model.removeEventListener(Event.CHANGE, this.handleChange);
			super.dispose();
		}
		
		public override function getMarkers():Vector.<Object> {
			var result:Vector.<Object> = new Vector.<Object>;
			result.push({param: 'value', x: 0, y: 35 / 2, dir: 'left', type: 'in'});
			return result;
		}
		
		private function handleChange(event:Event):void {
			var node:INode = event.target as INode;
			var msg:String = node.getValue('value');
			this.text.text = msg ? msg : '';
		}
	}
}