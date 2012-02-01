package ru.gotoandstop.nodes{
import flash.events.Event;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
	 * @author tmshv
	 */
	public class CombinedVertex extends Vertex{
		private var v1:IVertex;
		private var v2:IVertex;

		public function CombinedVertex(v1:IVertex, v2:IVertex){
			super(v1.x, v2.y);

			this.v1 = v1;
			this.v1.addEventListener(Event.CHANGE, this.handleParamChange);
			this.v2 = v2;
			this.v2.addEventListener(Event.CHANGE, this.handleParamChange);
			this.recalc();
		}

		public function dispose():void{
			this.v1.removeEventListener(Event.CHANGE, this.handleParamChange);
			this.v2.removeEventListener(Event.CHANGE, this.handleParamChange);
			this.v1 = null;
			this.v2 = null;
		}

		private function recalc():void{
			super.setCoord(this.v1.x, this.v2.y);
		}

		private function handleParamChange(event:Event):void{
			this.recalc();
		}
	}
}
