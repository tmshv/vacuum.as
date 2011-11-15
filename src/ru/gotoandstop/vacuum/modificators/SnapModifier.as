package ru.gotoandstop.vacuum.modificators{
	import flash.geom.Point;
	
	import ru.gotoandstop.math.Calculate;
	import ru.gotoandstop.vacuum.core.Vertex;

	/**
	 *
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class SnapModifier implements IVertexModifier{
		private var list:Vector.<Vertex>;
		
		public function SnapModifier(list:Vector.<Vertex>){
			super();
			this.list = list;
		}
		
		public function modify(x:Number, y:Number):Point{
			var lol:uint = 10*10;
			var coord:Point = new Point(x, y);
			for each(var vtx:Vertex in this.list){
				var vtx_coord:Point = vtx.toPoint();
				var dist:Number = Calculate.distanceQuad(vtx_coord, coord);
				if(dist < lol){
					return vtx_coord;
				}
			}
			
			return coord;
		}
	}
}