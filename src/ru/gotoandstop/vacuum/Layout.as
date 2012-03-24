package ru.gotoandstop.vacuum{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import ru.gotoandstop.geom.Vector2D;
	import ru.gotoandstop.vacuum.core.Vertex;
	import ru.gotoandstop.values.IntValue;
	import ru.gotoandstop.values.NumberValue;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 *
	 * Creation date: May 2, 2011 (12:41:46 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
     *
	 */
	public class Layout extends EventDispatcher{
		private var _scale:NumberValue;
		public function get scale():NumberValue{
			return this._scale;
		}
		
		private var _center:Vertex;
		public function get center():Vertex{
			return this._center;
		}
		
		private var _directionX:IntValue;
		public function get directionX():IntValue{
			return this._directionX;
		}
		
		private var _directionY:IntValue;
		public function get directionY():IntValue{
			return this._directionY;
		}
		
		private var changed:Boolean;
		private var _locked:Boolean;
		public function get locked():Boolean{
			return this._locked;
		}
		
		public function Layout(){
			super();
			this._scale = new NumberValue(1);
			this._center = new Vertex();
			this._directionX = new DirectionValue();
			this._directionY = new DirectionValue();
		}
		
		public function screenCoordToVertex(x:Number, y:Number):Vertex{
			return new Vertex(
				(x - this.center.x) / this.scale.value,
				(y - this.center.y) / this.scale.value
			);
//			return new Point(
//				x / this.layout.scale.value,
//				y / this.layout.scale.value
//			);
		}
		
		public function lock():void{
			this._locked = true;
		}
		
		public function unlock():void{
			this._locked = false;
			if(this.changed){
				this.update();
			}
		}
		
		public function update():void{
			if(!this.locked){
				super.dispatchEvent(new Event(Event.CHANGE));
				this.changed = false;
			}
		}
	}
}
import ru.gotoandstop.values.IntValue;

internal class DirectionValue extends IntValue{
	public override function set value(value:int):void{
		value = value < 0 ? -1 : 1;
		super.value = value;
	}
	
	public function DirectionValue(value:int=1){
		
	}
}