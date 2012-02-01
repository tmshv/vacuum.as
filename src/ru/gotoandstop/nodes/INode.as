package ru.gotoandstop.nodes{
import flash.events.IEventDispatcher;

/**
	 * @author tmshv
	 */
	public interface INode extends IEventDispatcher{
		function get name():String;
		function set name(value:String):void;
		function get type():String;
		function getValue(key:String):*;
		function setValue(key:String, value:*):void;
		function getParams():Vector.<String>;
	}
}
