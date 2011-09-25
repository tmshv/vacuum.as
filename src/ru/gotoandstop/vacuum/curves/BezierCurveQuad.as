package ru.gotoandstop.vacuum.curves{
	import flash.events.Event;
	import flash.geom.Bezier;
	import flash.geom.Point;
	
	import ru.gotoandstop.values.IntValue;
	import ru.gotoandstop.vacuum.core.Vertex;

	/**
	 * B(t) = (1-t)^2*P1 + 2t(1-t)*P1 + t^2*P2;
	 * Creation date: Apr 18, 2011 (4:08:40 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BezierCurveQuad{
		public function BezierCurveQuad(s:Vertex, e:Vertex, c:Vertex){
			this.line = new Bezier(s.getPosition(), e.getPosition(), c.getPosition());
			
			s.addEventListener(Event.CHANGE, this.handleDotChange);
			e.addEventListener(Event.CHANGE, this.handleDotChange);
			c.addEventListener(Event.CHANGE, this.handleDotChange);
		}
		
		private function handleDotChange(event:Event):void{
			
		}
	}
}