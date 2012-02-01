package ru.gotoandstop.nodes{
import flash.events.Event;

import ru.gotoandstop.vacuum.core.IVertex;

/**
	 * @author tmshv
	 */
	public class VacuumEvent extends Event{
		public static const ADDED_VERTEX:String = 'addedVertex';
		public static const REMOVED_VERTEX:String = 'removedVertex';

		private var _vertex:IVertex;
		public function get vertex():IVertex{
			return this._vertex;
		}
		
		public function VacuumEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, vertex:IVertex=null){
			super(type, bubbles, cancelable);
			this._vertex = vertex;
		}
		
		public override function clone():Event{
			return new VacuumEvent(super.type, super.bubbles, super.cancelable, this.vertex);
		}
	}
}
