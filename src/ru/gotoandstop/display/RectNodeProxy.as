package ru.gotoandstop.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import ru.gotoandstop.nodes.datatypes.INode;
	import ru.gotoandstop.values.IValue;
	import ru.gotoandstop.values.NumberValue;
	
	/**
	 * ...
	 * @author Roman Timashev
	 */
	public class RectNodeProxy
	{
		private var rect:Sprite;
		private var node:INode;
		
		public function RectNodeProxy(rect:Sprite, node:INode)
		{
			this.rect = rect;
			this.node = node;
			this.node.addEventListener(Event.CHANGE , this.handleChange);
			this.handleChange(null);
		}
		
		private function handleChange(event:Event):void
		{
			this.rect.x = this.getValue('x');
			this.rect.y = this.getValue('y');
			
			this.rect.graphics.clear();
			this.rect.graphics.beginFill(0x000000, 0.5);
			this.rect.graphics.drawRect(0, 0, this.getValue('width'), this.getValue('height'));
		}
		
		private function getValue(key:String):Number
		{
			
//			var value:NumberValue = this.node.getValue(key) as NumberValue;
//			if (value)
//			{
//				return value.value;
//			}
//			else
//			{
//				return 0;
//			}
			return 0;
		}
	
	}

}