package ru.gotoandstop.vacuum.modificators{
import flash.geom.Point;

import ru.gotoandstop.math.Calculate;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class SnapModifier implements IVertexModifier{
        private var _active:Boolean;
    
		private var list:Vector.<IVertex>;
        private var thresholdQuad:uint;
		
		public function SnapModifier(list:Vector.<IVertex>, threshold:uint=10){
			super();
			this.list = list;
            thresholdQuad = threshold * threshold;
		}
		
		public function modify(x:Number, y:Number):Point{
            var coord:Point = new Point(x, y);
            if(active){
                for each(var vtx:Vertex in this.list){
                    var vtx_coord:Point = vtx.toPoint();
                    var dist:Number = Calculate.distanceQuad(vtx_coord, coord);
                    if(dist < thresholdQuad){
                        return vtx_coord;
                    }
                }
            }
			return coord;
		}

    public function get active():Boolean {
        return _active;
    }

    public function set active(value:Boolean):void {
        _active = value;
    }
}
}