package ru.gotoandstop.vacuum{
	import flash.display.Shape;
	import flash.events.Event;
	import ru.gotoandstop.vacuum.core.Vertex;
	
	
	/**
	 *
	 * Creation date: May 1, 2011 (5:15:07 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class InactiveDot extends Shape{
		private var vertex:Vertex;
		
		public function InactiveDot(vertex:Vertex){
			super();
			this.vertex = vertex;
			
			this.vertex.addEventListener(Event.CHANGE, this.handleVertexChange);
			this.configure(vertex);
			
			this.draw();
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
		}
		
		private function draw():void{
			super.graphics.clear();
			super.graphics.lineStyle(0);
			super.graphics.beginFill(0xffffff);
			super.graphics.drawCircle(0, 0, 2);
			super.graphics.endFill();
		}
		
		private function configure(vertex:Vertex):void{
			super.x = vertex.x;
			super.y = vertex.y;
		}
		
		private function handleVertexChange(event:Event):void{
			const vertex:Vertex = event.target as Vertex;
			this.configure(vertex);
		}
		
		private function handleRemovedFromStage(event:Event):void{
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			this.vertex.removeEventListener(Event.CHANGE, this.handleVertexChange);
		}
	}
}