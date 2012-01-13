package ru.gotoandstop.vacuum.core{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 *
	 * Creation date: May 1, 2011 (1:28:18 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Vertex extends EventDispatcher implements IVertex{
		private var _x:Number;
		public function get x():Number{
			return this._x;
		}
		public function set x(value:Number):void{
			this._x = value;
			this.changed = true;
			this.update();
		}
		
		private var _y:Number;
		public function get y():Number{
			return this._y;
		}
		public function set y(value:Number):void{
			this._y = value;
			this.changed = true;
			this.update();
		}
		
		private var changed:Boolean;
		private var _locked:Boolean;
		public function get locked():Boolean{
			return this._locked;
		}
		
		public function Vertex(x:Number=0, y:Number=0){
			this.x = x;
			this.y = y;
		}
		
		public function setCoord(x:Number, y:Number):void{
			this.lock();
			this.x = x;
			this.y = y;
			this.unlock();
		}
		
		public function getCoord():Point{
			return new Point(this.x, this.y);
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
		
		public override function toString():String{
			return this.toPoint().toString();
		}
		
		public function toPoint():Point{
			return new Point(this.x, this.y);
		}
	}
}