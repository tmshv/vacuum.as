package ru.gotoandstop.vacuum{
	import flash.display.Graphics;
	
	/**
	 *
	 * Creation date: May 5, 2011 (8:09:08 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class GraphicsCanvas implements ICanvas{
		protected var canvas:Graphics;
		public function GraphicsCanvas(canvas:Graphics){
			this.canvas = canvas;
		}
		
		public function clear():void{
			this.canvas.clear();
		}
		
		public function draw(...coords):void{
			this.clear();
			this.canvas.lineStyle(0);
			this.canvas.moveTo(coords[0], coords[1]);
			
			const length:uint = coords.length;
			for(var i:uint; i<length; i+=2){
				var x:Number = coords[i];
				var y:Number = coords[i+1];
				
				this.canvas.lineTo(x, y);
			}
		}
	}
}