package ru.gotoandstop.vacuum.view{
	import flash.display.Graphics;
	
	/**
	 *
	 * Creation date: Jun 2, 2011 (1:34:29 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class CrossIcon extends VertexIcon{
		public function CrossIcon(stroke:uint, size:uint=2){
			super();
			
			var stroke_alpha:Number = ((stroke >> 24 & 0xff) / 0xff);
			var stroke_color:uint = stroke & 0xffffff;
			
			var canvas:Graphics = graphics;
			canvas.clear();
			super.drawInvisibleRect(size);
			if(stroke_alpha) canvas.lineStyle(0, stroke_color, stroke_alpha);
			canvas.moveTo(-size, 0);
			canvas.lineTo(size, 0);
			canvas.moveTo(0, -size);
			canvas.lineTo(0, size);
		}
	}
}