package ru.gotoandstop.vacuum.view{
	import flash.display.Graphics;
	
	/**
	 *
	 * Creation date: Jun 2, 2011 (1:34:03 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RectIcon extends VertexIcon{
		public function RectIcon(stroke:uint, fill:uint, size:uint=4){
			super();
			
			var fill_alpha:Number = ((fill >> 24 & 0xff) / 0xff);
			var fill_color:uint = fill & 0xffffff;
			
			var stroke_alpha:Number = ((stroke >> 24 & 0xff) / 0xff);
			var stroke_color:uint = stroke & 0xffffff;
			
			var canvas:Graphics = graphics;
			var s:uint = size;
			var s2:uint = s >> 1;
			canvas.clear();
			super.drawInvisibleCircle(size+2);
			if(fill_alpha) canvas.beginFill(fill_color, fill_alpha);
			if(stroke_alpha) canvas.lineStyle(0, stroke_color, stroke_alpha);
			canvas.drawRect(-s2, -s2, s, s);
		}
	}
}