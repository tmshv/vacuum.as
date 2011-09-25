package ru.gotoandstop.vacuum{
	import flash.events.IEventDispatcher;

	/**
	 * Интерфейс определяет айтем, способный выделяться среди других )))
	 * Creation date: Jun 3, 2011 (9:18:01 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface ISelectable extends IEventDispatcher{
		function isSelected():Boolean;
		function select():void;
		function deselect():void;
	}
}