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

			modifyX = Boolean(mask >> 1 & 1);
			modifyY = Boolean(mask & 1);
			
			target = source;
			target.addEventListener(Event.CHANGE, handleParamChange);
			recalc();
		}

		public function dispose():void{
			target.removeEventListener(Event.CHANGE, handleParamChange);
			target = null;
		}

		private function recalc():void{
			var x:Number = modifyX ? target.x : super.x;
			var y:Number = modifyY ? target.y : super.y;

			super.setCoord(x, y);
		}

		private function handleParamChange(event:Event):void{
			recalc();
		}
	}
}
