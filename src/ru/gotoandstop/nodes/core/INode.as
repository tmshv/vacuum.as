package ru.gotoandstop.nodes.core {
import flash.events.IEventDispatcher;

import ru.gotoandstop.IDisposable;

/**
 * @author tmshv
 */
public interface INode extends IEventDispatcher, IDisposable {
    function get lastTransfer():TransportObject;

    function set lastTransfer(value:TransportObject):void;

	function get id():String;

	function set id(value:String):void;

	function get type():String;

	function set type(value:String):void;

    function get system():INodeSystem;

    function set system(value:INodeSystem):void;

    function update():void;

	function get(key:String):*;

	function set(key:String, value:*):void;

    function exist(key:String):Boolean;

    function kill(key:String):void;

	function getParams():Vector.<String>;

    function on(key:String, listener:Function, useWeakReference:Boolean = false):void;

    function off(key:String, listener:Function):void;
}
}
