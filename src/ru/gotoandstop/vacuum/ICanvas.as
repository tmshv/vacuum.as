package ru.gotoandstop.vacuum{
	
	/**
	 *
	 * Creation date: May 5, 2011 (8:03:14 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface ICanvas{
		function draw(...coords):void;
		function clear():void;
	}
}