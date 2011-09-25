package ru.gotoandstop.vacuum.controllers{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 * Creation date: Jul 23, 2011
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class MoveController extends EventDispatcher{
		private var target:DisplayObject;
		private var _mouseDown:Boolean;
		
		public function MoveController(target:DisplayObject){
			super();
			this.target = target;
		}
		
		/**
		 * Если мышь нажата, менять модель по вьюшке 
		 * @param event
		 * 
		 */
		private function handleMouseMove(event:MouseEvent):void{
			if(this._mouseDown){
				var dx:Number = this._lastPosition.x - event.stageX;
				var dy:Number = this._lastPosition.y - event.stageY;
				
				var dp:Point = this.dot.screenCoordToIdeal(-dx, -dy);
				
				this.dot.vertex.lock();
				this.dot.vertex.x += dp.x;
				this.dot.vertex.y += dp.y;
				this.dot.vertex.unlock();
			}
			
			this._lastPosition.x = event.stageX;
			this._lastPosition.y = event.stageY;
		}
		
		/**
		 * При нажатии на вьюшку перемещеиние происходит с помощью дрега 
		 * @param event
		 * 
		 */
		private function handleMouseDown(event:MouseEvent):void{
			this.dot.startDrag();
		}

	
	
	
	private function handleMouseUp(event:MouseEvent):void{
		//			this._mouseDown = false;
		this.dot.active.value = false;
		this.dot.stopDrag();
	}
	}
}