package ru.gotoandstop.vacuum.controllers{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import ru.gotoandstop.math.Calculate;
	import ru.gotoandstop.vacuum.core.Vertex;
	import ru.gotoandstop.vacuum.view.VertexView;
	
	
	/**
	 *
	 * Creation date: May 2, 2011 (3:58:36 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BezierVertexController extends EventDispatcher{
		private var spin:Vertex;
		private var control1:VertexView;
		private var control2:VertexView;
		
		public function BezierVertexController(spinVertex:Vertex, control1:VertexView, control2:VertexView){
			super();
			this.spin = spinVertex;
			this.control1 = control1;
			this.control2 = control2;
			
			this.control1.vertex.addEventListener(Event.CHANGE, this.handleControl1Changed);
			this.control2.vertex.addEventListener(Event.CHANGE, this.handleControl2Changed);
			
			this.locate(this.control2.vertex, this.control1.vertex);
		}
		
		private function handleControl1Changed(event:Event):void{
			if(this.control1.active.value){
				this.locate(this.control2.vertex, this.control1.vertex);	
			}
		}
		
		private function handleControl2Changed(event:Event):void{
			if(this.control2.active.value){
				this.locate(this.control1.vertex, this.control2.vertex);	
			}
		}
		
		/**
		 * Располагает вершину vertex относительно вершины relative 
		 * @param vertex
		 * @param relative
		 * 
		 */
		private function locate(vertex:Vertex, relative:Vertex):void{
			var angle:Number = Calculate.angle(
				new Point(relative.x, relative.y),
				new Point(this.spin.x, this.spin.y)
			);
			var dist:Number = Calculate.distance(
				new Point(relative.x, relative.y),
				new Point(this.spin.x, this.spin.y)
			);
			
			angle += Math.PI;
			
			vertex.x = this.spin.x - Math.cos(angle) * dist;
			vertex.y = this.spin.y - Math.sin(angle) * dist;
		}
	}
}