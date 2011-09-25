package ru.gotoandstop.vacuum{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ru.gotoandstop.vacuum.curves.BezierCurveQuad;
	import ru.gotoandstop.vacuum.curves.DotController;
	import ru.gotoandstop.math.Calculate;
	
	[SWF(width=800, height=600, frameRate=50)]
	
	/**
	 *
	 * Creation date: Apr 18, 2011 (3:11:19 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Curves extends Sprite{
		public function Curves(){
			this.createCurve();
		}
		
		private function createCurve():void{
			var a1:ActiveDot = this.createDot();
			this.locateDot(a1);
			super.addChild(a1);			
			new DotController(a1);
			
			var a2:ActiveDot = this.createDot();
			this.locateDot(a2);
			super.addChild(a2);			
			new DotController(a2);
			
			var c:ActiveDot = this.createDot();
			this.locateDot(c);
			super.addChild(c);			
			new DotController(c);
			
			new BezierCurveQuad(a1, a2, c);
		}
		
		private function createDot():ActiveDot{
			return new ActiveDot();
		}
		
		/**
		 * тут можно было бы использовать декоратор 
		 * @param dot
		 * 
		 */
		private function locateDot(dot:ActiveDot):void{
			var coord:Point = this.getRandomCoord();
			dot.setPosition(coord.x, coord.y);
		}
		
		private function getRandomCoord():Point{
			return new Point(
				Calculate.random(10, super.stage.stageWidth-20, true),
				Calculate.random(10, super.stage.stageHeight-20, true)
			);
		}
	}
}