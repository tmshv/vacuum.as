package ru.gotoandstop.nodes{
import flash.events.Event;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
	 * @author tmshv
	 */
	public class CloneVertex extends Vertex implements IDisposable{
		private var target:IVertex;
		private var modifyX:Boolean;
		private var modifyY:Boolean;

		public function CloneVertex(source:IVertex, mask:uint){
			super();

			this.modifyX = Boolean(mask >> 1 & 1);
			this.modifyY = Boolean(mask & 1);
			
			this.target = source;
			this.target.addEventListener(Event.CHANGE, this.handleParamChange);
			this.recalc();
		}

		public function dispose():void{
			this.target.removeEventListener(Event.CHANGE, this.handleParamChange);
		}

		private function recalc():void{
			var x:Number = this.modifyX ? this.target.x : super.x;
			var y:Number = this.modifyY ? this.target.y : super.y;

			super.setCoord(x, y);
		}

		private function handleParamChange(event:Event):void{
			this.recalc();
		}
	}
}
