package ru.gotoandstop.vacuum.view{
	import flash.display.Graphics;
	
	/**
	 *
	 * Creation date: Jun 2, 2011 (1:34:40 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class PointIcon extends VertexIcon{
		public function PointIcon(stroke:uint, size:uint=2){
			super();
			
			var stroke_alpha:Number = ((stroke >> 24 & 0xff) / 0xff);
			var stroke_color:uint = stroke & 0xffffff;
			
			var canvas:Graphics = graphics;
			canvas.clear();
			super.drawInvisibleCircle(size*2);
			if(stroke_alpha){
				//			canvas.lineStyle(0, stroke_color, stroke_alpha);
				canvas.beginFill(stroke, stroke_alpha);
			}
			var s:uint = size;
			var s2:Number = s >> 2;
			canvas.drawRect(-s2, -s2, s, s);
		}
	}
}