package ru.gotoandstop.nodes{
import flash.events.Event;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.values.NumberValue;

/**
	 * @author tmshv
	 */
	public class InterpolationVertex extends Vertex implements IDisposable{
		private var _percent:NumberValue;

		public function get percent():NumberValue{
			return this._percent;
		}

		private var v1:IVertex;
		private var v2:IVertex;
		private var modifyX:Boolean;
		private var modifyY:Boolean;

		public function InterpolationVertex(v1:IVertex, v2:IVertex, percent:Object, mask:uint){
			super();

			this.modifyX = Boolean(mask >> 1 && 1);
			this.modifyY = Boolean(mask && 1);

			if (percent is Number){
				this._percent = new NumberValue(Number(percent));
			} else if (percent is NumberValue){
				this._percent = percent as NumberValue;
			}
			this.v1 = v1;
			this.v2 = v2;

			this.v1.addEventListener(Event.CHANGE, this.handleParamChange);
			this.v2.addEventListener(Event.CHANGE, this.handleParamChange);
			this.percent.addEventListener(Event.CHANGE, this.handleParamChange);

			this.recalc();
		}

		public function dispose():void{
			this.v1.removeEventListener(Event.CHANGE, this.handleParamChange);
			this.v2.removeEventListener(Event.CHANGE, this.handleParamChange);
			this.percent.removeEventListener(Event.CHANGE, this.handleParamChange);
		}

		private function recalc():void{
			var x:Number = this.modifyX ? this.v1.x + (this.v2.x - v1.x) * this.percent.value : super.x;
			var y:Number = this.modifyY ? this.v1.y + (this.v2.y - v1.y) * this.percent.value : super.y;

			super.setCoord(x, y);
		}

		private function handleParamChange(event:Event):void{
			this.recalc();
		}
	}
}
