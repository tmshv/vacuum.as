package ru.gotoandstop.vacuum{
	import flash.display.Graphics;
	
	/**
	 *
	 * Creation date: May 5, 2011 (8:25:32 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BezierCurveCubicRenderer extends GraphicsCanvas{
		public function BezierCurveCubicRenderer(canvas:Graphics){
			super(canvas);
		}
		
		public override function draw(...coords):void{
			this.clear();
			this.canvas.lineStyle(0);
			this.canvas.moveTo(coords[0], coords[1]);
			
			var s:Number = 0.02;
			for(var t:Number=0; t<=1.01; t+= s){
				var x:Number = this.calculateValue(t, coords[0], coords[2], coords[4], coords[6]);
				var y:Number = this.calculateValue(t, coords[1], coords[3], coords[5], coords[7]);
				
				this.canvas.lineTo(x, y);
			}	
		}
		
		public override function clear():void{
			this.canvas.clear();
		}
		
		private function calculateValue(t:Number, p0:Number, p1:Number, p2:Number, p3:Number):Number{
			t = Math.max(t, 0);
			t = Math.min(t, 1);
			var td:Number = 1 - t;
			//B(t) = (1-t)^3*P0 + 3t(1-t)^2*P1 + 3t^2*(1-t)*P2 + t^3*P3;
			return (
				td*td*td * p0 +
				3*t*td*td * p1 +
				3*t*t*td * p2 +
				t*t*t * p3
			);
		}
	}
}