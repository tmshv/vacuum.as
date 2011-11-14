package ru.gotoandstop.vacuum.controllers{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ru.gotoandstop.vacuum.core.IDisposable;
	import ru.gotoandstop.vacuum.view.VertexView;
	
	/**
	 *
	 * Creation date: May 2, 2011 (3:04:51 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class MouseController extends EventDispatcher implements IDisposable{
		private var dot:VertexView;
		private var _mouseDown:Boolean;
		private var _lastPosition:Point;
		
		private var _mouseOffset:Point;
		
		public function MouseController(dot:VertexView){
			super();
			this._lastPosition = new Point();
			
			this.dot = dot;
			this.dot.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
 			this.dot.stage.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			this.dot.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
		}
		
		public function dispose():void{
			this.dot.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
			this.dot.stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			this.dot = null;
		}
		
		public function startMove():void{
			this._mouseDown = true;
			this.dot.active.value = true;
			this._mouseOffset = new Point(-this.dot.mouseX, -this.dot.mouseY);
		}
		
		public function stopMove():void{
			this._mouseDown = false;
			this.dot.active.value = false;
		}
		
		/**
		 * Если мышь нажата, менять модель 
		 * @param event
		 * 
		 */
		private function handleMouseMove(event:MouseEvent):void{
			if(this._mouseDown){
				var coord:Point = VertexView.screenToLayout(
					this.dot,
					event.stageX + this._mouseOffset.x,
					event.stageY + this._mouseOffset.y
				);
				
				this.dot.vertex.lock();
				this.dot.vertex.x = coord.x;
				this.dot.vertex.y = coord.y;
				this.dot.vertex.unlock();
			}
		}
		
		/**
		 * При нажатии на вьюшку она активирутся.
		 * @param event
		 * 
		 */
		private function handleMouseDown(event:MouseEvent):void{
			this.startMove();
		}
		
		private function handleMouseUp(event:MouseEvent):void{
			this.stopMove();
		}
	}
}