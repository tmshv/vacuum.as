package ru.gotoandstop.vacuum{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	
	/**
	 *
	 * Creation date: Apr 27, 2011 (5:36:39 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Arrow extends Sprite{
		private const TO_RADIAN:Number = Math.PI / 180;
		
		private var _rootRadius:uint;
		private var _arrowLength:uint;
		private var _cornerDegree:uint;
		
		public function Arrow(length:uint, rootRadius:uint=5, arrowLength:uint=5, cornerDegree:uint=80){
			super();
			this._arrowLength = arrowLength;
			this._cornerDegree = cornerDegree;
			this._rootRadius = rootRadius;
			this.draw(length);
		}
		
		public function setLength(value:uint):void{
			if(value > 10){
				this.draw(value);
			}
		}
		
		private function draw(length:uint):void{
			const line_length:uint = length - this._rootRadius;
			const arrow_length:uint = this._arrowLength;// * length * 0.03;
			
			const g:Graphics = super.graphics;
			g.clear();
			g.lineStyle(0, 0x000000, 1, true);
			
			//root
			g.drawCircle(0, 0, this._rootRadius);
			
			//line
			g.moveTo(this._rootRadius, 0);
			g.lineTo(line_length, 0);
			
			//arrow
			var rad:Number = Math.PI - (this._cornerDegree/2) * this.TO_RADIAN;
			var ax:Number = Math.cos(rad) * arrow_length;
			var ay:Number = Math.sin(rad) * arrow_length;
			g.moveTo(line_length, 0);
			g.lineTo(line_length+ax, ay);
			g.moveTo(line_length, 0);
			g.lineTo(line_length+ax, -ay);
			
			g.endFill();
		}
	}
}