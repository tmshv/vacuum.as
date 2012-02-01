package ru.gotoandstop.vacuum.controllers{
	import flash.events.Event;
	import flash.geom.Point;
	
	import ru.gotoandstop.IDisposable;
	import ru.gotoandstop.math.Calculate;
	import ru.gotoandstop.vacuum.core.IVertex;
	import ru.gotoandstop.vacuum.core.Vertex;
	import ru.gotoandstop.vacuum.view.VertexView;

	/**
	 *
	 * Creation date: Jul 25, 2011
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SaveDistanceController implements IDisposable{
		private var prevDist:Number;
		
		private var dot:VertexView;
		private var relative:IVertex;
		
		private var dependecies:Vector.<Vertex>;
		
		public function SaveDistanceController(vertex:VertexView, relative:IVertex){
			this.dependecies = new Vector.<Vertex>();
			
			this.dot = vertex;
			this.relative = relative;
			
			this.dot.vertex.addEventListener(Event.CHANGE, this.handleVertexChange);
			this.relative.addEventListener(Event.CHANGE, this.handleRelativeChange);
			
			this.updateDist();
		}
		
		public function dispose():void{
			this.dot.vertex.removeEventListener(Event.CHANGE, this.handleVertexChange);
			this.relative.removeEventListener(Event.CHANGE, this.handleRelativeChange);
			this.dot = null;
			this.relative = null;
		}
		
		public function addDependencyVertex(vertex:IVertex):void{
			this.dependecies.push(vertex);
		}
		
		private function handleVertexChange(event:Event):void{
			if(!this.dot.active.value){
				this.updateDist();
				return;
			}
			
			var new_dist:Number = Calculate.distance(this.dot.vertex.toPoint(), this.relative.toPoint());
			var ratio:Number = new_dist / this.prevDist;
			for each(var vert:Vertex in this.dependecies){
				this.relocate(vert, ratio);
			}
			
			this.updateDist(new_dist);
		}
		
		private function handleRelativeChange(event:Event):void{
			this.updateDist();
		}
		
		private function relocate(vertex:Vertex, distMultiplyer:Number):void{
			var v:Point = vertex.toPoint();
			var r:Point = this.relative.toPoint();
			
			var angle:Number = Calculate.angle(v, r);
			var dist:Number = Calculate.distance(v, r);
			
			dist *= distMultiplyer;
			
			vertex.x = r.x + Math.cos(angle) * dist;
			vertex.y = r.y + Math.sin(angle) * dist;
		}
		
		private function updateDist(value:Number=NaN):void{
			if(value){
				this.prevDist = value;
			}else{
				this.prevDist = Calculate.distance(this.dot.vertex.toPoint(), this.relative.toPoint());	
			}
		}
	}
}