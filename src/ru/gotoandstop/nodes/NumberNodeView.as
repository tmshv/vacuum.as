package ru.gotoandstop.nodes {
import com.bit101.components.NumericStepper;
import com.bit101.components.Panel;

import flash.events.Event;

import ru.gotoandstop.values.NumberValue;

/**
	 * @author tmshv
	 */
	public class NumberNodeView extends NodeView {
		private var currentValue:Number;
		private var num:NumericStepper;
		
		public function NumberNodeView(model:NumberNode, vacuum:VacuumLayout, vo:NodeVO) {
			super(vacuum, vo);
			super.model = model;
			
			var h:Panel = new Panel();
			h.height = 35;
			super.addChild(h);
//			super.setDragTarget(h);
			
			this.num = new NumericStepper(null, 10, 10, this.handleNumeric);
			super.addChild(this.num);
			
			var value:NumberValue = model.getValue('value');
			value.addEventListener(Event.CHANGE, this.handleChange);
			num.value = value.value;
			this.currentValue = num.value;
		}
		
		public override function dispose():void {
			this.num.removeEventListener(Event.CHANGE, this.handleNumeric);
			super.model.getValue('value').removeEventListener(Event.CHANGE, this.handleChange);
			this.num = null;
			
			super.dispose();
		}
		
		private function handleNumeric(event:Event):void {
			var num:NumericStepper = event.target as NumericStepper;
			this.currentValue = num.value;
			super.model.setValue('value', this.currentValue);
		}
		
		public override function getMarkers():Vector.<Object> {
			var result:Vector.<Object> = new Vector.<Object>;
			result.push({param: 'value', x: 100, y: 35 / 2, dir: 'right', type: 'out'});
			return result;
		}
		
		private function handleChange(event:Event):void {
			var value:NumberValue = event.target as NumberValue;
			if (this.currentValue != value.value) {
				this.num.value = value.value;
				this.currentValue = value.value;
			}
		}
	}
}
