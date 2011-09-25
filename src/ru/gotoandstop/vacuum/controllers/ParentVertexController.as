package ru.gotoandstop.vacuum.controllers{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import ru.gotoandstop.vacuum.core.IDisposable;
	import ru.gotoandstop.vacuum.core.Vertex;
	
	
	/**
	 *
	 * Creation date: May 2, 2011 (2:48:08 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class ParentVertexController extends EventDispatcher implements IDisposable{
		private var children:Vector.<Vertex>;
		private var parent:Vertex;
		
		private var lastPosition:Point;
		
		public function ParentVertexController(parentVertex:Vertex){
			super();
			this.children = new Vector.<Vertex>();
			this.makeParent(parentVertex);
		}
		
		public function dispose():void{
			this.parent.removeEventListener(Event.CHANGE, this.handleParentChanged);
		}
		
		public function add(vertex:Vertex, makeParent:Boolean=false):void{
			this.children.push(vertex);
			if(makeParent){
				if(this.parent) this.clearParent(this.parent);
				this.makeParent(vertex);
			}
		}
		
		private function handleParentChanged(event:Event):void{
			var dx:Number = this.parent.x - this.lastPosition.x;
			var dy:Number = this.parent.y - this.lastPosition.y;
			
			for each(var child:Vertex in this.children){
				child.x += dx;
				child.y += dy;
			}
			
			this.lastPosition.x = this.parent.x;
			this.lastPosition.y = this.parent.y;
		}
		
		private function clearParent(vertex:Vertex):void{
			vertex.removeEventListener(Event.CHANGE, this.handleParentChanged);
		}
		
		public function makeParent(vertex:Vertex):void{
			this.parent = vertex;
			this.parent.addEventListener(Event.CHANGE, this.handleParentChanged);
			this.lastPosition = new Point(this.parent.x, this.parent.y);
		}
		
		public function clear():void{
			if(this.parent) this.clearParent(this.parent);
			this.children = new Vector.<Vertex>();
		}
	}
}