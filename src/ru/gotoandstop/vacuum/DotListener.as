package ru.gotoandstop.vacuum{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import ru.gotoandstop.vacuum.core.Vertex;
	
	
	/**
	 *
	 * Creation date: May 2, 2011 (1:28:33 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class DotListener extends EventDispatcher{
		public function DotListener(view:DisplayObject, model:Vertex){
			super();
		}
	}
}