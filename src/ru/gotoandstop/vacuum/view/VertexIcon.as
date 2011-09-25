package ru.gotoandstop.vacuum.view{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	 *
	 * Creation date: Jun 2, 2011 (1:33:55 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class VertexIcon extends Sprite{
		public function VertexIcon(){
			super();
		}
		
		protected function drawInvisibleRect(size:uint):void{
			var canvas:Graphics = super.graphics;
			var s2:uint = size >> 2;
			canvas.beginFill(0, 0);
			canvas.drawRect(-s2, -s2, size, size);
		}
		
		protected function drawInvisibleCircle(radius:uint):void{
			var canvas:Graphics = super.graphics;
			canvas.beginFill(0, 0.01);
			canvas.drawCircle(0, 0, radius);
		}
	}
}