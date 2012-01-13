package ru.gotoandstop.vacuum.core{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	/**
	 *
	 * creation date: Jan 13, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public interface IVertex extends IEventDispatcher{
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function setCoord(x:Number, y:Number):void;
		function getCoord(params:Object=null):Point;
	}
}