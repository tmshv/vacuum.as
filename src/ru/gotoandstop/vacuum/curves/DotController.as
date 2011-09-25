package ru.gotoandstop.vacuum.curves{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;	
	
	/**
	 *
	 * Creation date: Apr 29, 2011 (6:42:52 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class DotController extends EventDispatcher{
		public function DotController(dot:Sprite){
			super();
			dot.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
			dot.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
		}
		
		private function handleMouseDown(event:MouseEvent):void{
			var dot:Sprite = event.currentTarget as Sprite;
			dot.startDrag();
		}
		
		private function handleMouseUp(event:MouseEvent):void{
			var dot:Sprite = event.currentTarget as Sprite;
			dot.stopDrag();			
		}
	}
}