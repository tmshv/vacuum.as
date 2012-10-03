package ru.gotoandstop.vacuum{
import flash.display.GraphicsPath;
import flash.display.Sprite;
import flash.events.Event;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.render.IDrawer;

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

        public var drawer:IDrawer;
		
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
			drawSpline2(spline.getCommands());
		}

		private function drawSpline2(data:GraphicsPath):void{
            if(drawer) {
                drawer.draw(graphics, data)
            }else{
                graphics.clear();
                graphics.lineStyle(0, 0x000000);
                graphics.drawPath(data.commands, data.data, data.winding);
            }
		}
	}
}