package ru.gotoandstop.nodes{
import flash.events.Event;
import flash.geom.Point;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
	 * @author tmshv
	 */
	public class ScreenConvertVertex extends Vertex implements IVertex, IDisposable{
		private var target:IVertex;

		public function ScreenConvertVertex(target:IVertex){
			super();
			this.target = target;
			this.target.addEventListener(Event.CHANGE, this.updateFromTarget);
			this.updateFromTarget();
		}

		private function updateFromTarget(event:Event=null):void{
			var p:Point = this.target.getCoord({localToGlobal:new Point()});
			super.setCoord(p.x, p.y);
		}

		public function dispose():void{
			this.target.removeEventListener(Event.CHANGE, this.updateFromTarget);
			this.target = null;
		}
	}
}
