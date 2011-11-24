package ru.gotoandstop.vacuum{
	import flash.display.GraphicsPath;
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
		private var controls:Vector.<Boolean>;
		
		public var closed:Boolean;
		private var changed:Boolean;
		
		public function Spline(){
			this.vertices = new Vector.<Vertex>();
			this.controls = new Vector.<Boolean>();
		}
		
		public override function dispose():void{
			for each(var v:Vertex in this.vertices){
				v.removeEventListener(Event.CHANGE, this.handleVertexChanged);
			}
		}
		
		public function addVertex(vertex:Vertex, asControl:Boolean=false):void{
			this.vertices.push(vertex);
			this.controls.push(asControl);
			
			vertex.addEventListener(Event.CHANGE, this.handleVertexChanged);
			
			this.changed = true;
			this.update();
		}
		
		public function addVertexXY(x:Number, y:Number):void{
			this.addVertex(new Vertex(x, y));
		}
		
		/**
		 * Устаревший метод, будет заменен методом getCommands 
		 * @return 
		 * 
		 */
		public function getInstructions():Vector.<Point>{
			var result:Vector.<Point> = new Vector.<Point>();
			for each(var v:Vertex in this.vertices){
				result.push(new Point(v.x, v.y));
			}
			return result;
		}
		
		public function getCommands():GraphicsPath{
			var data:GraphicsPath = new GraphicsPath();
			
			//nothing to draw
			if(this.vertices.length < 2){
				return data;
			}
			
			var vertices:Vector.<Vertex> = this.vertices.concat();
			var controls:Vector.<Boolean> = this.controls.concat();
			
			if(this.closed){
				vertices.push(this.vertices[0]);
				controls.push(this.controls[0]);
			}
			
			var first:Vertex = vertices.shift();
			controls.shift();
			data.moveTo(first.x, first.y);
			
			var length:uint = vertices.length;
			for(var i:uint=0; i<length; i++){
				var draw_cubic_bezier:Boolean = false;
				var draw_quadrantic_bezier:Boolean = false;
				
				var v1:Vertex = vertices[i];
				var c1:Boolean = controls[i];
				var c2:Boolean;
				
				//можно нарисовать куад-безье
				if(length-i > 2){
					c2 = controls[i+1];
					
					//в правилах указано нарисовать куад-безье
					if(c1 && c2){
						draw_cubic_bezier = true;
					}
				}
				
				draw_quadrantic_bezier = length-i > 1 && c1;
				
				// нарисуется кривая
				if(draw_cubic_bezier || draw_quadrantic_bezier){
					var v2:Vertex = vertices[i+1];
					if(draw_cubic_bezier){
						var c3:Boolean = controls[i+2];
						var v3:Vertex = vertices[i+2];
						if(!c3) data.cubicCurveTo(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
						i += 1;
					}else if(draw_quadrantic_bezier){
						c2 = controls[i+1];
						if(!c2) data.curveTo(v1.x, v1.y, v2.x, v2.y);
					}
				}
				
				// нарисуется линия
				else{
					if(!c1) data.lineTo(v1.x, v1.y);	
				}
			}
			
			return data;
		}
		
		private function getDrawLineData():GraphicsPath{
			var first:Vertex = this.vertices[0];
			var second:Vertex = this.vertices[1];
			
			var data:GraphicsPath = new GraphicsPath();
			data.moveTo(first.x, first.y);
			data.lineTo(second.x, second.y);
			
			return data;
		}
		
		private function getDrawCurveLineData():GraphicsPath{
			var first:Vertex = this.vertices[0];
			var second:Vertex = this.vertices[1];
			var third:Vertex = this.vertices[2];
			
			var data:GraphicsPath = new GraphicsPath();
			data.moveTo(first.x, first.y);
			data.curveTo(second.x, second.y, third.x, third.y);
			
			return data;
		}
		
		private function drawCubicCurve(path:GraphicsPath, c1:Vertex, c2:Vertex, a:Vertex):void{
			path.cubicCurveTo(c1.x, c1.y, c2.x, c2.y, a.x, a.y);
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