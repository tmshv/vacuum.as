package ru.gotoandstop.nodes{
import flash.events.Event;

/**
	 *
	 * creation date: Jan 21, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class NodeSystemEvent extends Event{
		public static const ADDED_NODE:String = 'addedNode';
		public static const REMOVED_NODE:String = 'removedNode';
		
		private var _node:INode;
		public function get node():INode{
			return this._node;
		}
		
		public function NodeSystemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, node:INode=null){
			super(type, bubbles, cancelable);
			this._node = node;
		}
		
		public override function clone():Event{
			return new NodeSystemEvent(super.type, super.bubbles, super.cancelable, this.node);
		}
	}
}