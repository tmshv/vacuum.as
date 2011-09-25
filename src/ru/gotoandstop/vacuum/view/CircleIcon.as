package ru.gotoandstop.vacuum.view{
	import flash.display.Graphics;
	
	/**
	 *
	 * Creation date: Jun 2, 2011 (1:34:14 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class CircleIcon extends VertexIcon{
		public function CircleIcon(stroke:uint, fill:uint, radius:uint=2){
			super();
			
			var fill_alpha:Number = ((fill >> 24 & 0xff) / 0xff);
			var fill_color:uint = fill & 0xffffff;
			
			var stroke_alpha:Number = ((stroke >> 24 & 0xff) / 0xff);
			var stroke_color:uint = stroke & 0xffffff;
			
			var canvas:Graphics = graphics;
			canvas.clear();
			if(fill_alpha) canvas.beginFill(fill_color, fill_alpha);
			if(stroke_alpha) canvas.lineStyle(0, stroke_color, stroke_alpha);
			canvas.drawCircle(0, 0, radius);
		}
	}
}