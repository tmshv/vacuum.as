package ru.gotoandstop.nodes{
import flash.geom.Point;

/**
	 * @author tmshv
	 */
	public class NodeVO{
		public var type:String;
		public var clip:Class;
		public var clipScale:Point;
		public var exclude:Vector.<Object> = new Vector.<Object>();

		public var model:Class;

		public function NodeVO(){
		}
	}
}
