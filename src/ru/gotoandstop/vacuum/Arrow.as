package ru.gotoandstop.vacuum{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	/**
	 *
	 * Creation date: Apr 27, 2011 (5:36:39 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Arrow extends Sprite{
		private const TO_RADIAN:Number = Math.PI / 180;
		private const TO_DEGREE:Number = 180 / Math.PI;
		
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
		
		public function setPosition(x:Number, y:Number):void{
			super.x = x;
			super.y = y;
		}
		
		public function setCoord(coord:Point):void{
			this.setPosition(coord.x, coord.y);
		}
		
		public function setLength(value:uint):void{
			if(value > 10){
				this.draw(value);
			}
		}
		
		public function lookAt(x:Number, y:Number):void{
			var dx:Number = x - super.x;
			var dy:Number = y - super.y;
			var rad:Number = Math.atan2(dy, dx);
			super.rotation = rad * this.TO_DEGREE;
		}
		
		public function lookAtPoint(point:Point):void{
			this.lookAt(point.x, point.y);
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