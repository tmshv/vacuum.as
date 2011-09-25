package ru.gotoandstop.vacuum{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ru.gotoandstop.vacuum.core.IDisposable;
	
	
	/**
	 *
	 * Creation date: May 1, 2011 (2:01:47 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SplineView extends Sprite implements IDisposable{
		private var _spline:Spline;
		public function get spline():Spline{
			return this._spline;
		}
		
		public function SplineView(spline:Spline){
			super();
			this._spline = spline;
			this.spline.addEventListener(Event.CHANGE, this.handleSplineChanged);
			this.drawSpline(this.spline.getInstructions(), this.spline.closed);
		}
		
		public function dispose():void{
			this.spline.removeEventListener(Event.CHANGE, this.handleSplineChanged);
			this._spline = null;
		}
		
		private function handleSplineChanged(event:Event):void{
			const spline:Spline = event.target as Spline;
			this.drawSpline(spline.getInstructions(), spline.closed);
		}
		
		private function drawSpline(coords:Vector.<Point>, close:Boolean=false):void{
			const first:Point = coords.shift();
			super.graphics.clear();
			super.graphics.lineStyle(0);
			super.graphics.moveTo(first.x, first.y);
			for each(var coord:Point in coords){
				super.graphics.lineTo(coord.x, coord.y);
			}
			if(close){
				super.graphics.lineTo(first.x, first.y);
			}
		}
	}
}