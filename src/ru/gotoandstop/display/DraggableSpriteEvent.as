package ru.gotoandstop.display{
	import flash.events.Event;

	/**
	 * @author tmshv
	 */
	public class DraggableSpriteEvent extends Event{
		public static const MOVE:String = 'move';
		
		public function DraggableSpriteEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false){
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event{
			return new DraggableSpriteEvent(super.type, super.bubbles, super.cancelable);
		}
	}
}
