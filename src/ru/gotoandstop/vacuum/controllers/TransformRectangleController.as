package ru.gotoandstop.vacuum.controllers{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ru.gotoandstop.math.Calculate;
	import ru.gotoandstop.vacuum.core.IDisposable;
	import ru.gotoandstop.vacuum.core.Vertex;
	import ru.gotoandstop.vacuum.view.VertexView;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 *
	 * Creation date: May 18, 2011 (6:47:52 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class TransformRectangleController extends EventDispatcher implements IDisposable{
		private var topleft:VertexView;
		
		private var idealWidth:Number;
		private var idealHeight:Number;
		
		private var tl:Vertex;
		private var t:Vertex;
		private var tr:Vertex;
		private var r:Vertex;
		private var br:Vertex;
		private var b:Vertex;
		private var bl:Vertex;
		private var l:Vertex;
		private var a:Vertex;
		
		private var viewsByVertex:Dictionary;
		
//		public var width:uint;
//		public var height:uint;
		public var scaleX:Number;
		public var scaleY:Number;
		public var rotation:Number;
		public var topLeftX:Number;
		public var topLeftY:Number;
		
		public function TransformRectangleController(lt:VertexView, rt:VertexView, rb:VertexView, lb:VertexView, center:VertexView){
			super();
			this.topleft = lt;
			this.tl = lt.vertex;
//			this.t = new Vertex(xw2, y);
			this.tr = rt.vertex;
//			this.r = new Vertex(xw, yh2);
			this.br = rb.vertex;
//			this.b = new Vertex(xw2, yh);
			this.bl = lb.vertex;
//			this.l = new Vertex(x, yh2);
			this.a = center.vertex;
			
			this.idealWidth = Calculate.distance(this.tl.toPoint(), this.tr.toPoint());
			this.idealHeight = Calculate.distance(this.tl.toPoint(), this.bl.toPoint());
			
			this.viewsByVertex = new Dictionary();
			this.viewsByVertex[this.tl] = lt;
			this.viewsByVertex[this.tr] = rt;
			this.viewsByVertex[this.bl] = lb;
			this.viewsByVertex[this.br] = rb;
			
			this.addListenerToVertex(this.tl);
			this.addListenerToVertex(this.tr);
			this.addListenerToVertex(this.br);
			this.addListenerToVertex(this.bl);
//			this.addListenerToVertex(this.a);
			
			var con:SaveDistanceController;
			con = new SaveDistanceController(lt, this.a);
			con.addDependencyVertex(this.tr);
			con.addDependencyVertex(this.br);
			con.addDependencyVertex(this.bl);
			
			con = new SaveDistanceController(rt, this.a);
			con.addDependencyVertex(this.tl);
			con.addDependencyVertex(this.br);
			con.addDependencyVertex(this.bl);
			
			con = new SaveDistanceController(rb, this.a);
			con.addDependencyVertex(this.tl);
			con.addDependencyVertex(this.tr);
			con.addDependencyVertex(this.bl);
			
			con = new SaveDistanceController(lb, this.a);
			con.addDependencyVertex(this.tl);
			con.addDependencyVertex(this.tr);
			con.addDependencyVertex(this.br);
			
			var con2:SaveAngleController;
			con2 = new SaveAngleController(lt, this.a);
			con2.addDependencyVertex(this.tr);
			con2.addDependencyVertex(this.br);
			con2.addDependencyVertex(this.bl);
			
			con2 = new SaveAngleController(rt, this.a);
			con2.addDependencyVertex(this.tl);
			con2.addDependencyVertex(this.br);
			con2.addDependencyVertex(this.bl);
			
			con2 = new SaveAngleController(rb, this.a);
			con2.addDependencyVertex(this.tl);
			con2.addDependencyVertex(this.tr);
			con2.addDependencyVertex(this.bl);
			
			con2 = new SaveAngleController(lb, this.a);
			con2.addDependencyVertex(this.tl);
			con2.addDependencyVertex(this.tr);
			con2.addDependencyVertex(this.br);
			
			this.topleft.addEventListener(Event.EXIT_FRAME, this.handleExitFrame);
		}
		
		public function dispose():void{
			this.removeListenerFromVertex(this.tl);
			this.removeListenerFromVertex(this.tr);
			this.removeListenerFromVertex(this.br);
			this.removeListenerFromVertex(this.bl);
//			this.removeListenerFromVertex(this.a);
		}
		
		private function addListenerToVertex(vertex:Vertex):void{
			vertex.addEventListener(Event.CHANGE, this.handlerCornerVertexChanged);
		}
		
		private function removeListenerFromVertex(vertex:Vertex):void{
			vertex.removeEventListener(Event.CHANGE, this.handlerCornerVertexChanged);
		}
		
		private function handlerCornerVertexChanged(event:Event):void{
			return;
			var view:VertexView = this.viewsByVertex[event.target];
			if(view.active.value){
				this.topLeftX = this.topleft.x;
				this.topLeftY = this.topleft.y;
				
				var top_left:Point = this.tl.toPoint();
				var top_right:Point = this.tr.toPoint();
				var bottom_left:Point = this.bl.toPoint();
				
				this.rotation = Calculate.degree(top_left, top_right);			
				this.width = Calculate.distance(top_left, top_right);
				this.height = Calculate.distance(top_left, bottom_left);
				
				super.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function handleExitFrame(event:Event):void{
			this.topLeftX = this.topleft.x;
			this.topLeftY = this.topleft.y;
			
			var top_left:Point = this.tl.toPoint();
			var top_right:Point = this.tr.toPoint();
			var bottom_left:Point = this.bl.toPoint();
			
			var width:Number = Calculate.distance(top_left, top_right);
			var height:Number = Calculate.distance(top_left, bottom_left);
			
			this.rotation = Calculate.degree(top_left, top_right);
			this.scaleX = width / this.idealWidth;
			this.scaleY = height / this.idealHeight;
			
			super.dispatchEvent(new Event(Event.CHANGE));			
		}
	}
}