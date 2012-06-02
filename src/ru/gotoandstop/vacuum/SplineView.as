package ru.gotoandstop.vacuum{
import flash.display.DisplayObject;
import flash.display.GraphicsPath;
import flash.display.Sprite;
import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

import ru.gotoandstop.IDisposable;

import ru.gotoandstop.mvc.BaseView;
	import ru.gotoandstop.mvc.IModel;
		
	/**
	 *
	 * Creation date: May 1, 2011 (2:01:47 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SplineView extends Sprite implements IDisposable{
		private var _spline:Spline;
		public function get spline():Spline{
			return _spline;
		}
		
		public function SplineView(spline:Spline){
			super();
			_spline = spline;
			_spline.addEventListener(Event.CHANGE, this.handleSplineChanged);
			drawSpline2(_spline.getCommands());
		}
		
		public function dispose():void{
			spline.removeEventListener(Event.CHANGE, this.handleSplineChanged);
			_spline = null;
		}
		
		private function handleSplineChanged(event:Event):void{
			const spline:Spline = event.target as Spline;
			drawSpline2(spline.getCommands());
		}
		
		private function drawSpline2(data:GraphicsPath):void{
			super.graphics.clear();
			super.graphics.lineStyle(0);
			super.graphics.drawPath(data.commands, data.data, data.winding);
		}
	}
}