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
			var vnum:uint = this.vertices.length;
			if(vnum < 2){
				//nothing to draw
				return data;
			}else if(vnum < 3){
				//draw line
				return this.getDrawLineData();
			}else if(vnum < 4){
				//draw curve
				return this.getDrawCurveLineData();
			}
			
			var vertices:Vector.<Vertex> = this.vertices.concat();
			var controls:Vector.<Boolean> = this.controls.concat();
			
			var first:Vertex = vertices[0];
			
			if(this.closed){
				vertices.push(first);
				controls.push(this.controls[0]);
			}
			
			data.moveTo(first.x, first.y);
			
			var v1:Vertex;
			var v2:Vertex;
			var v3:Vertex;
			var c1:Boolean;
			var c2:Boolean;
			var c3:Boolean;
			
			const length:uint = vertices.length;
			for(var i:uint=1; i<length; i+=3){
				v1 = vertices[i];
				c1 = controls[i];
				
				v2 = vertices[i+1];
				c2 = controls[i+1];
				
				v3 = vertices[i+2];
				c3 = controls[i+2];
				
				if(c1 && c2){
					data.cubicCurveTo(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
//					i += 2;
				}else if(c1){
					data.curveTo(v1.x, v1.y, v2.x, v2.x);
//					i++;
				}else if(!c2){
					data.lineTo(v1.x, v1.y);
				}
			}
			
			trace(i)
			
//			const last:uint = vertices.length - 1;
//			v3 = vertices[last];
//			c3 = controls[last];
//			
//			v2 = vertices[last-1];
//			c2 = controls[last-1];
//			
//			v1 = vertices[last-2];
//			c1 = controls[last-2];
//			
//			if(c1 && c2){
//				data.cubicCurveTo(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);
//				i += 2;
//			}else if(c1){
//				data.curveTo(v1.x, v1.y, v2.x, v2.x);
//				i++;
//			}else if(!c2){
//				data.lineTo(v1.x, v1.y);
//			}
			
//			if(this.closed){
//				commands.push(this.controls[cmd ? 6 : 2]);
//				coords.push(first.x);
//				coords.push(first.y);
//			}
			
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