package ru.gotoandstop.vacuum{
	
	/**
	 *
	 * Creation date: May 1, 2011 (5:32:54 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class LineSpline extends Spline{
		public function LineSpline(x1:Number, y1:Number, x2:Number, y2:Number){
			super();
			super.addVertexXY(x1, y1);
			super.addVertexXY(x2, y2);
		}
	}
}