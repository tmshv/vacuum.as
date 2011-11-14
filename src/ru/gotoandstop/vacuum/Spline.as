package ru.gotoandstop.vacuum{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import ru.gotoandstop.mvc.BaseModel;
	import ru.gotoandstop.vacuum.core.IDisposable;
	import ru.gotoandstop.vacuum.core.Vertex;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 *
	 * Creation date: May 1, 2011 (1:24:59 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Spline extends BaseModel{
		private var vertices:Vector.<Vertex>;
		
		public var closed:Boolean;
		private var changed:Boolean;
		
		public function Spline(){
			this.vertices = new Vector.<Vertex>();
		}
		
		public override function dispose():void{
			for each(var v:Vertex in this.vertices){
				v.removeEventListener(Event.CHANGE, this.handleVertexChanged);
			}
		}
		
		public function addVertex(vertex:Vertex):void{
			this.vertices.push(vertex);
			vertex.addEventListener(Event.CHANGE, this.handleVertexChanged);
			
			this.changed = true;
			this.update();
		}
		
		public function addVertexXY(x:Number, y:Number):void{
			this.addVertex(new Vertex(x, y));
		}
		
		public function getInstructions():Vector.<Point>{
			var result:Vector.<Point> = new Vector.<Point>();
			for each(var v:Vertex in this.vertices){
				result.push(new Point(v.x, v.y));
			}
			return result;
		}
		
		public function getLineList():Vector.<Line>{
			var list:Vector.<Line> = new Vector.<Line>();
			const length:uint = this.vertices.length - 1;
			for(var i:uint; i<length; i++){
				var v1:Vertex = this.vertices[i];
				var v2:Vertex = this.vertices[i+1];
				list.push(new Line(v1, v2));
			}
			if(this.closed){
				list.push(new Line(this.vertices[length], this.vertices[0]));
			}
			return list;
		}
		
		private function handleVertexChanged(event:Event):void{
			super.dispatchEvent(event);
		}
		
		public override function unlock():void{
			super.unlock();
			if(this.changed){
				this.update();
			}
		}
		
		public override function update():void{
			if(!this.locked){
				super.dispatchEvent(new Event(Event.CHANGE));
				this.changed = false;
			}
		}
	}
}