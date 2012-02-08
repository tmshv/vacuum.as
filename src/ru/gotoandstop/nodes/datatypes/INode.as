package ru.gotoandstop.nodes.datatypes {
import flash.events.IEventDispatcher;

import ru.gotoandstop.IDisposable;

/**
 * @author tmshv
 */
public interface INode extends IEventDispatcher, IDisposable {
	function get name():String;

	function set name(value:String):void;

	function get type():String;

	function set type(value:String):void;

	function update():void;

	function getKeyValue(key:String):*;

	function setKeyValue(key:String, value:*):void;

	function getParams():Vector.<String>;
}
}
