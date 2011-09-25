package ru.gotoandstop.vacuum.splines{
	import flash.geom.Rectangle;
	
	import ru.gotoandstop.vacuum.Spline;
	import ru.gotoandstop.vacuum.core.Vertex;
	
	/**
	 *
	 * Creation date: May 1, 2011 (1:34:30 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class RectSpline extends Spline{
		protected var lt:Vertex;
		protected var lb:Vertex;
		protected var rt:Vertex;
		protected var rb:Vertex;
		
		public function RectSpline(x:Number=0, y:Number=0, width:Number=0, height:Number=0){
			super();
			
			var left:Number = x;
			var right:Number = x + width;
			var top:Number = y;
			var bottom:Number = y + height;
			
			this.lb = new Vertex(left, bottom);
			super.addVertex(this.lb);
			
			this.lt = new Vertex(left, top);
			super.addVertex(this.lt);
			
			this.rt = new Vertex(right, top);
			super.addVertex(this.rt);
			
			this.rb = new Vertex(right, bottom);
			super.addVertex(this.rb);
		}
		
		public function setLeft(value:Number):void{
			super.lock();
			this.lt.x = value;
			this.lb.x = value;
			super.unlock();
		}
		
		public function setRight(value:Number):void{
			super.lock();
			this.rt.x = value;
			this.rb.x = value;
			super.unlock();			
		}
		
		public function setTop(value:Number):void{
			super.lock();
			this.lt.y = value;
			this.rt.y = value;
			super.unlock();
		}
		
		public function setBottom(value:Number):void{
			super.lock();
			this.lb.y = value;
			this.rb.y = value;
			super.unlock();
		}
		
		public function toRectangle():Rectangle{
			var rect:Rectangle = new Rectangle();
			rect.left = this.lt.x;
			rect.top = this.lt.y;
			rect.right = this.rb.x;
			rect.bottom = this.rb.y;
			return rect;
		}
	}
}