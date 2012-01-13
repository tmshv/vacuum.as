package ru.gotoandstop.vacuum.controllers{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ru.gotoandstop.vacuum.splines.RectSpline;
	
	
	/**
	 *
	 * Creation date: Jun 3, 2011 (4:10:55 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SelectRectangle extends RectSpline{
		private var downCoord:Point;
		
		private var target:IEventDispatcher;
		
		public function SelectRectangle(target:DisplayObject, x:Number=0, y:Number=0, width:Number=0, height:Number=0){
			super(x, y, width, height);
			super.closed = true;
			
			this.target = target;
//			this.target.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
			this.target.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			this.target.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
		}
		
		public override function dispose():void{
			this.target.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			this.target.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
			super.dispose();
		}
		
//		public function getRectangle():
		
		private function handleMouseDown(event:MouseEvent):void{
//			this.downCoord = new Point(event.stageX, event.stageY);
//			
//			this.active = new RectSpline(this.downCoord.x, this.downCoord.y);
//			this.active.closed = true;
//			this.lines.addChild(new SplineView(this.active));
//			this.intersect.addSpline(this.active);
		}
		
		private function handleMouseUp(event:MouseEvent):void{
//			this.mousePressed = false;
		}
		
		private function handleMouseMove(event:MouseEvent):void{
			super.setRight(event.stageX);
			super.setBottom(event.stageY);
		}
	}
}