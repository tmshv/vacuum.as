package ru.gotoandstop.vacuum.controllers{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import ru.gotoandstop.math.Calculate;
	import ru.gotoandstop.vacuum.core.Vertex;
	
	
	/**
	 *
	 * Creation date: Jun 2, 2011 (2:22:25 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SnapController extends EventDispatcher{
		private var list:Vector.<Vertex>;
		private var changes:Point;
		private var vertex:Vertex;
		
		public function SnapController(vertex:Vertex, other:Vector.<Vertex>, target:IEventDispatcher){
			super();
			this.list = other;
			this.vertex = vertex;
			this.vertex.addEventListener(Event.CHANGE, this.handleVertexChange);
			this.update(this.vertex);
			target.addEventListener(Event.EXIT_FRAME, this.handleExitFrame);
		}
		
		private function handleVertexChange(event:Event):void{
//			trace(event)
			this.update(event.target as Vertex);
		}
		
		private function update(vertex:Vertex):void{
			var lol:uint = 10*10;
			var coord:Point = vertex.toPoint();
			for each(var vtx:Vertex in this.list){
				if(vtx == vertex) continue;
				
				var dist:Number = Calculate.distanceQuad(vtx.toPoint(), coord);
				if(dist < lol){
					//trace('lol', vertex.lock, vtx)
					
//					vertex.x = 100;
					
					this.changes = new Point();
					this.changes.x = vtx.x;
					this.changes.y = vtx.y;
					
//					vertex.lock();
//					vertex.x = vtx.x;
//					vertex.y = vtx.y;
//					vertex.unlock();
					return;
				}
			}
		}
		
		private function handleExitFrame(event:Event):void{
			if(this.changes){
				this.vertex.lock();
				this.vertex.x = this.changes.x;
				this.vertex.y = this.changes.y;
				this.vertex.unlock();
				this.changes = null;
			}
		}
	}
}