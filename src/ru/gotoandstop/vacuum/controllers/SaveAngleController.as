package ru.gotoandstop.vacuum.controllers{
	import flash.events.Event;
	import flash.geom.Point;
	
	import ru.gotoandstop.IDisposable;
	import ru.gotoandstop.math.Calculate;
	import ru.gotoandstop.vacuum.core.IVertex;
	import ru.gotoandstop.vacuum.core.Vertex;
	import ru.gotoandstop.vacuum.view.VertexView;

	/**
	 * Контроллер устанавливает зависимые вершины 
	 * Creation date: Jul 25, 2011
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SaveAngleController implements IDisposable{
		private var prevValue:Number;
		
		private var dot:VertexView;
		private var relative:IVertex;
		
		private var dependecies:Vector.<Vertex>;
		
		public function SaveAngleController(vertex:VertexView, relative:IVertex){
			this.dependecies = new Vector.<Vertex>();
			
			this.dot = vertex;
			this.relative = relative;
			
			this.dot.vertex.addEventListener(Event.CHANGE, this.handleVertexChange);
			this.relative.addEventListener(Event.CHANGE, this.handleRelativeChange);
			
			this.updateAngle();
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
				this.updateAngle();
				return;
			}
			
			var new_angle:Number = Calculate.angle(this.dot.vertex.toPoint(), this.relative.toPoint());
			var delta:Number = new_angle - this.prevValue;
			for each(var vert:Vertex in this.dependecies){
				this.relocate(vert, delta);
			}
			
			this.updateAngle(new_angle);
		}
		
		private function handleRelativeChange(event:Event):void{
			this.updateAngle();
		}
		
		private function relocate(vertex:Vertex, value:Number):void{
			var v:Point = vertex.toPoint();
			var r:Point = this.relative.toPoint();
			
			var angle:Number = Calculate.angle(v, r);
			angle += value;
			var dist:Number = Calculate.distance(v, r);
			
			vertex.x = r.x + Math.cos(angle) * dist;
			vertex.y = r.y + Math.sin(angle) * dist;
		}
		
		private function updateAngle(value:Number=NaN):void{
			if(value){
				this.prevValue = value;
			}else{
				this.prevValue = Calculate.angle(this.dot.vertex.toPoint(), this.relative.toPoint());	
			}
		}
	}
}