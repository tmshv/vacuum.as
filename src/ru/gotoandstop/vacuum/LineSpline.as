package ru.gotoandstop.vacuum{
import flash.events.IEventDispatcher;

import ru.gotoandstop.vacuum.core.Vertex;
	
	/**
	 *
	 * Creation date: May 1, 2011 (5:32:54 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class LineSpline extends Spline{
		public function LineSpline(target:IEventDispatcher, onEnterFrame:Boolean = true, x1:Number=0, y1:Number=0, x2:Number=0, y2:Number=0){
			super(target, onEnterFrame);
			super.addVertex(new Vertex(x1, y1));
			super.addVertex(new Vertex(x2, y2));
		}
	}
}