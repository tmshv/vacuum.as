package ru.gotoandstop.vacuum.view{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ru.gotoandstop.vacuum.Layout;
	import ru.gotoandstop.vacuum.core.IDisposable;
	import ru.gotoandstop.vacuum.core.IVertex;
	import ru.gotoandstop.vacuum.core.Vertex;
	import ru.gotoandstop.values.BooleanValue;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * Класс занимается отрисовкой точки <code>vertex<code> на экране
	 * Creation date: Jun 2, 2011 (1:33:42 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class VertexView extends Sprite implements IDisposable, IVertex{
		public static function screenToLayout(view:VertexView, x:Number, y:Number):Point{
			return new Point(
				(x - view.layout.center.x) / view.layout.scale.value,
				(y - view.layout.center.y) / view.layout.scale.value
			);
		}
		
		private var _active:BooleanValue;
		/**
		 * Булево значение, отвечающее за состояние точки. true - вьюшка будет слушать модель.
		 * @return 
		 * 
		 */
		public function get active():BooleanValue{
			return this._active;
		}
		
		private var _vertex:Vertex;
		/**
		 * модель данных для отрисовки 
		 * @return 
		 * 
		 */
		public function get vertex():Vertex{
			return this._vertex;
		}
		
		private var _icon:VertexIcon;
		/**
		 * Внешний вид точки 
		 * @return 
		 * 
		 */
		public function get icon():VertexIcon{
			return this._icon;
		}
		
		private var layout:Layout;
		
		public function VertexView(vertex:Vertex, layout:Layout, icon:VertexIcon=null){
			super();
			this._active = new BooleanValue();
			
			this.setIcon(icon ? icon : new EmptyIcon());
			
			this.layout = layout;
			this.layout.scale.addEventListener(Event.CHANGE, this.handleLayoutChange);
			this.layout.center.addEventListener(Event.CHANGE, this.handleLayoutChange);
			
			this._vertex = vertex;
			this.vertex.addEventListener(Event.CHANGE, this.handleVertexChange);
			this.configure(vertex);
			
//			super.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
//			super.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
//			super.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
		}
		
		public function dispose():void{
			this.vertex.removeEventListener(Event.CHANGE, this.handleVertexChange);
			//this._vertex = null;
			
			this.layout.scale.removeEventListener(Event.CHANGE, this.handleLayoutChange);
			this.layout.center.removeEventListener(Event.CHANGE, this.handleLayoutChange);
			//this.layout = null;
			
			//super.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
			//super.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
		}
		
		public function setCoord(x:Number, y:Number):void{
			this.vertex.setCoord(x, y);
		}
		
		public function getCoord():Point{
			return new Point(this.x, this.y);
		}
		
		public function setIcon(icon:VertexIcon):void{
			if(this._icon){
				super.removeChild(this._icon);
			}
			this._icon = icon;
			super.addChild(this._icon);
		}
		
		public function getPosition(withLayout:Boolean=false):Point{
			if(withLayout){
				var x:Number = (super.x - this.layout.center.x) / this.layout.scale.value;
				var y:Number = (super.y - this.layout.center.y) / this.layout.scale.value;
				return new Point(x, y);
			}else{
				return new Point(super.x, super.y);	
			}
		}
		
		public function screenCoordToIdeal(x:Number, y:Number):Point{
//			return new Point(
//				(x - this.layout.center.x) / this.layout.scale.value,
//				(y - this.layout.center.y) / this.layout.scale.value
//			);
			return new Point(
				x / this.layout.scale.value,
				y / this.layout.scale.value
			);
		}
		
		/**
		 * Устанавливает вьюшку в координату, соответстующую <code>vertex</code>.
		 * Действие происходит только в том случае, если <code>active</code> имеет значение true. 
		 * @param vertex
		 * 
		 */
		private function configure(vertex:Vertex):void{
			//if(!this.active.value){
				super.x = this.layout.center.x + vertex.x*this.layout.scale.value;
				super.y = this.layout.center.y + vertex.y*this.layout.scale.value;
			//}
		}
		
//		private function handleMouseDown(event:MouseEvent):void{
//			this.active.value = true;
//			super.startDrag();
//		}
//		
//		private function handleMouseUp(event:MouseEvent):void{
//			this.active.value = false;
//			super.stopDrag();
//		}
		
		private function handleVertexChange(event:Event):void{
			const vertex:Vertex = event.target as Vertex;
			this.configure(vertex);
		}
		
		private function handleLayoutChange(event:Event):void{
			this.configure(this.vertex);
		}
		
		private function handleRemovedFromStage(event:Event):void{
			this.dispose();
		}
		
		
		
		
		
		
		
		private var controllers:Object = {};
		public function addController(c:*, name:String):void{
			this.controllers[name] = c;
		}
		public function getController(name:String):*{
			return this.controllers[name];
		}
	}
}