package ru.gotoandstop.nodes
{
import flash.events.Event;

import ru.gotoandstop.values.NumberValue;

/**
	 * ...
	 * @author Roman Timashev
	 */
	public class RectNode extends NodeModel
	{
		public var x:String;
		public var y:String;
		public var width:String;
		public var height:String;
		
		private var _x:NumberValue;
		private var _y:NumberValue;
		private var _width:NumberValue;
		private var _height:NumberValue;
		
		public override function get type():String
		{
			return 'rect';
		}
		
		public function RectNode()
		{
		
		}
		
		private function setProp(textProp:String, value:NumberValue):void
		{
			const textNum:String = '_' + textProp;
			if (value)
				this[textProp] = value.name;
			else
				this[textProp] = '';
			
			if (this[textNum])
				this[textNum].removeEventListener(Event.CHANGE, this.handleChange);
			
			this[textNum] = value;
			if (this[textNum])
				this[textNum].addEventListener(Event.CHANGE, this.handleChange);
				
			this.handleChange(null);
		}
		
		public override function setValue(key:String, value:*):void
		{
			if (key == 'x')
				this.setProp('x', value);
			else if (key == 'y')
				this.setProp('y', value);
			else if (key == 'width')
				this.setProp('width', value);
			else if (key == 'height')
				this.setProp('height', value);
			else
				super.setValue(key, value);
		}
		
		public override function getValue(key:String):*
		{
			if (key == 'x')
				return this._x;
			if (key == 'y')
				return this._y;
			if (key == 'width')
				return this._width;
			if (key == 'height')
				return this._height;
			return super.getValue(key);
		}
		
		public override function getParams():Vector.<String>
		{
			var vec:Vector.<String> = new Vector.<String>();
			vec.push('in float x');
			vec.push('in float y');
			vec.push('in float width');
			vec.push('in float height');
			return vec;
		}
		
		private function handleChange(event:Event):void
		{
			super.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}