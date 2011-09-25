package ru.gotoandstop.vacuum{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import ru.gotoandstop.vacuum.core.Vertex;
	
	/**
	 * (y1-y2)x + (x2-x1)y + (x1y2-x2y1) = 0
	 * a = (y1-y2)
	 * b = (x2-x1)
	 * c = (x1y2 - x2y1)
	 * 
	 * Intersection condition
	 * d = a1b2 - a2b1
	 * d != 0
	 * x = (b1с2-b2с1) / d
	 * y = (c1a2-c2a1) / d
	 * Creation date: May 1, 2011 (4:23:15 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class IntersectController{
		private var splines:Vector.<Spline>;
		private var dots:DisplayObjectContainer;
		
		private var intersects:Array;
		
		public function IntersectController(dotContainer:DisplayObjectContainer){
			super();
			this.dots = dotContainer;
			this.splines = new Vector.<Spline>();
			
			this.intersects = new Array();
		}
		
		public function addSpline(spline:Spline):void{
			this.splines.push(spline);
		}
		
		public function intersect(spline:Spline):void{
//			while(this.dots.numChildren) this.dots.removeChildAt(0);
			
			var lines:Vector.<Line> = spline.getLineList();
			
			for each(var spl:Spline in this.splines){
				if(spl == spline) continue;
				
				var spl_lines:Vector.<Line> = spl.getLineList();
				for each(var line:Line in lines){
					for each(var line2:Line in spl_lines){
						var dot:DisplayObject = this.findDot(line, line2);
						if(dot){
							this.removeDot(line, line2, dot);
						}
						
						var coord:Vertex = this.intersectLines(line, line2);
						if(coord){
							this.addDot(line, line2, coord);
						}
					}
				}
			}
		}
		
		private function findDot(line1:Line, line2:Line):DisplayObject{
			for each(var list:Array in this.intersects){
				var v1:Vertex = list[0] as Vertex;
				var v2:Vertex = list[1] as Vertex;
				var v3:Vertex = list[2] as Vertex;
				var v4:Vertex = list[3] as Vertex;
				
				var d1:Boolean = (v1 == line1.first);
				var d2:Boolean = (v2 == line1.second);
				var d3:Boolean = (v3 == line2.first);
				var d4:Boolean = (v4 == line2.second);
				
				if(d1 && d2 && d3 && d4){
					return list[4];
				}
			}
			
			return null;
		}
		
		private function removeDot(line1:Line, line2:Line, dot:DisplayObject):void{
			for(var i:uint; i<this.intersects.length; i++){
				var list:Array = this.intersects[i];
				
				var v1:Vertex = list[0] as Vertex;
				var v2:Vertex = list[1] as Vertex;
				var v3:Vertex = list[2] as Vertex;
				var v4:Vertex = list[3] as Vertex;
				
				var d1:Boolean = (v1 == line1.first);
				var d2:Boolean = (v2 == line1.second);
				var d3:Boolean = (v3 == line2.first);
				var d4:Boolean = (v4 == line2.second);
				
				if(d1 && d2 && d3 && d4){
					this.intersects.splice(i, 1);
				}
			}
			
			this.dots.removeChild(dot);
		}
		
		private function addDot(line1:Line, line2:Line, vertex:Vertex):void{
			var dot:DisplayObject = new InactiveDot(vertex);
			this.dots.addChild(dot);
			
			this.intersects.push([line1.first, line1.second, line2.first, line2.second, dot]);
		}
		
		private function intersectLines(line1:Line, line2:Line):Vertex{
			var a1:Number = line1.first.y - line1.second.y;
			var b1:Number = line1.second.x - line1.first.x;
			var c1:Number = (line1.first.x*line1.second.y) - (line1.second.x*line1.first.y);
			
			var a2:Number = line2.first.y - line2.second.y;
			var b2:Number = line2.second.x - line2.first.x;
			var c2:Number = (line2.first.x*line2.second.y) - (line2.second.x*line2.first.y);
			
			var d:Number = a1*b2 - a2*b1;
			if(d != 0){
				var x:Number = (b1*c2 - b2*c1) / d;
				var y:Number = (c1*a2 - c2*a1) / d;
				var vertex:Vertex = new Vertex(x, y);
				
				var on1:Boolean = this.onLine(line1, vertex);
				var on2:Boolean = this.onLine(line2, vertex);
				
				if(on1 && on2){
					return vertex;
				}else{
					return null;
				}
			}else{
				return null;
			}
		}
		
		private function onLine(line:Line, vertex:Vertex):Boolean{
			var fx:Number = Math.min(line.first.x, line.second.x);
			var fy:Number = Math.min(line.first.y, line.second.y);
			var sx:Number = Math.max(line.first.x, line.second.x);
			var sy:Number = Math.max(line.first.y, line.second.y);
			
			var vx:Number = vertex.x;
			var vy:Number = vertex.y;
			
			var x:Boolean = (vx >= fx) && (vx <= sx);
			var y:Boolean = (vy >= fy) && (vy <= sy);
			
			return x && y;
		}
	}
}