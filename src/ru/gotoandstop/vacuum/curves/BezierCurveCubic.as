package ru.gotoandstop.vacuum.curves{
	import flash.display.Graphics;
	import flash.events.Event;
	
	import ru.gotoandstop.IDisposable;
	import ru.gotoandstop.vacuum.ICanvas;
	import ru.gotoandstop.vacuum.core.IVertex;
	
	/**
	 * B(t) = (1-t)^3*P0 + 3t(1-t)^2*P1 + 3t^2*(1-t)*P2 + t^3*P3;
	 * 
	 * todo: сделать канвас интерфейсным классом
	 * Creation date: May 2, 2011 (12:06:04 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BezierCurveCubic implements IDisposable{
		private var v1:IVertex;
		private var v2:IVertex;
		private var v3:IVertex;
		private var v4:IVertex;
		
		private var canvas:ICanvas;
		
		public function BezierCurveCubic(v1:IVertex, v2:IVertex, v3:IVertex, v4:IVertex, canvas:ICanvas){
			this.v1 = v1;
			this.v2 = v2;
			this.v3 = v3;
			this.v4 = v4;
			
			this.v1.addEventListener(Event.CHANGE, this.handleVertexChange);
			this.v2.addEventListener(Event.CHANGE, this.handleVertexChange);
			this.v3.addEventListener(Event.CHANGE, this.handleVertexChange);
			this.v4.addEventListener(Event.CHANGE, this.handleVertexChange);
			
			this.canvas = canvas;
			this.draw();
		}
		
		public function dispose():void{
			this.v1.removeEventListener(Event.CHANGE, this.handleVertexChange);
			this.v2.removeEventListener(Event.CHANGE, this.handleVertexChange);
			this.v3.removeEventListener(Event.CHANGE, this.handleVertexChange);
			this.v4.removeEventListener(Event.CHANGE, this.handleVertexChange);
			this.v1 = null;
			this.v2 = null;
			this.v3 = null;
			this.v4 = null;
			this.canvas = null;
		}
		
		private function handleVertexChange(event:Event):void{
			this.draw();
		}
		
		private function draw():void{
			this.canvas.draw(
				this.v1.x, this.v1.y,
				this.v2.x, this.v2.y,
				this.v3.x, this.v3.y,
				this.v4.x, this.v4.y
			);
		}
	}
}