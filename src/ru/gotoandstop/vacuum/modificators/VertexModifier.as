package ru.gotoandstop.vacuum.modificators{
	import flash.events.Event;
	
	import ru.gotoandstop.math.Calculate;
	import ru.gotoandstop.vacuum.core.Vertex;
	
	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class VertexModifier extends Vertex{
		private var target:Vertex;
		
		public function VertexModifier(vertex:Vertex){
			super();
			this.target = vertex;
			this.target.addEventListener(Event.CHANGE, this.handleVertexChange);
			this.modify();
		}
		
		private function handleVertexChange(event:Event):void{
			this.modify();
		}
		
		private function modify():void{
			super.setCoord(
				Calculate.random(-10, 10) + this.target.x,
				Calculate.random(-10, 10) + this.target.y
			);
		}
	}
}