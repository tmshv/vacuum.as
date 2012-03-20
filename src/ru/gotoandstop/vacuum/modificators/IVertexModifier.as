package ru.gotoandstop.vacuum.modificators{
	import flash.geom.Point;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public interface IVertexModifier{
		function modify(x:Number, y:Number):Point;
        function get active():Boolean;
        function set active(value:Boolean):void;
	}
}