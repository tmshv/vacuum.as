package ru.gotoandstop.vacuum.controllers{
import flash.display.DisplayObjectContainer;
import flash.geom.Point;

import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.modificators.IVertexModifier;

/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class VertexContoller{
		private var model:Vertex;
	    public var container:DisplayObjectContainer;

		public function VertexContoller(container:DisplayObjectContainer){
			super();
            this.container = container;
			this.model = new Vertex();
		}
		
		public function addModifier(modifier:IVertexModifier):void{
			
		}
		
		public function setCoord(x:Number, y:Number):void{
			var coord:Point = new Point(x, y);
			for each(var modifier:IVertexModifier in []){
				coord = modifier.modify(coord.x, coord.y);
			}
			
			this.model.setCoord(coord.y, coord.y);
		}
	}
}