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
        private var xFromFirst:Boolean;

		public function CombinedVertex(v1:IVertex, v2:IVertex, xFromFirst:Boolean=true){
			super(v1.x, v2.y);
            this.xFromFirst = xFromFirst;
			this.v1 = v1;
			this.v1.addEventListener(Event.CHANGE, recalc);
			this.v2 = v2;
			this.v2.addEventListener(Event.CHANGE, recalc);
			recalc();
		}

		public function dispose():void{
			v1.removeEventListener(Event.CHANGE, recalc);
			v2.removeEventListener(Event.CHANGE, recalc);
			v1 = null;
			v2 = null;
		}

		private function recalc(event:Event=null):void{
            if(xFromFirst) {
                super.setCoord(v1.x, v2.y);
            }else{
                super.setCoord(v2.x, v1.y);
            }
		}
	}
}
