package ru.gotoandstop.vacuum{
	import flash.display.GraphicsPath;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ru.gotoandstop.mvc.BaseView;
	import ru.gotoandstop.mvc.IModel;
		
	/**
	 *
	 * Creation date: May 1, 2011 (2:01:47 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SplineView extends BaseView{
		private var _spline:Spline;
		public function get spline():Spline{
			return this._spline;
		}
		
		public override function get model():IModel{
			return this.spline;
		}
		
		public function SplineView(spline:Spline){
			super(spline);
			this._spline = spline;
			this.spline.addEventListener(Event.CHANGE, this.handleSplineChanged);
			this.drawSpline2(spline.getCommands());
		}
		
		public override function dispose():void{
			super.dispose();
			this.spline.removeEventListener(Event.CHANGE, this.handleSplineChanged);
			this._spline = null;
		}
		
		private function handleSplineChanged(event:Event):void{
			const spline:Spline = event.target as Spline;
			this.drawSpline2(spline.getCommands());
		}
		
		private function drawSpline2(data:GraphicsPath):void{
			super.graphics.clear();
			super.graphics.lineStyle(0);
			super.graphics.drawPath(data.commands, data.data, data.winding);
		}
	}
}