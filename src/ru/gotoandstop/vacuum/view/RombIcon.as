package ru.gotoandstop.vacuum.view{
	import flash.display.Graphics;
	
	/**
	 *
	 * Creation date: Jun 2, 2011 (1:38:24 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RombIcon extends VertexIcon{
		public function RombIcon(stroke:uint, fill:uint, size:uint=5){
			super();
			
			var fill_alpha:Number = ((fill >> 24 & 0xff) / 0xff);
			var fill_color:uint = fill & 0xffffff;
			
			var stroke_alpha:Number = ((stroke >> 24 & 0xff) / 0xff);
			var stroke_color:uint = stroke & 0xffffff;
			
			var canvas:Graphics = graphics;
			canvas.clear();
			if(fill_alpha) canvas.beginFill(fill_color, fill_alpha);
			if(stroke_alpha) canvas.lineStyle(0, stroke_color, stroke_alpha);
			canvas.moveTo(-size, 0);
			canvas.lineTo(0, -size);
			canvas.lineTo(size, 0);
			canvas.lineTo(0, size);
			canvas.lineTo(-size, 0);
		}
	}
}