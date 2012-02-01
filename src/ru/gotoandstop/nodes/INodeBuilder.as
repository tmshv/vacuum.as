package ru.gotoandstop.nodes{
import flash.display.DisplayObjectContainer;

/**
	 *
	 * creation date: Jan 21, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public interface INodeBuilder{
		function init(vo:NodeVO, container:DisplayObjectContainer, vacuum:VacuumLayout):void;
		function createNode(name:String, model:INode=null):Node;
		function get type():String;
	}
}