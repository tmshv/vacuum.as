package ru.gotoandstop.vacuum{
	import com.foxaweb.utils.Raster;
	
	import flash.geom.Point;
	
	/**
	 *
	 * Creation date: May 5, 2011 (8:09:22 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class BezierCurveCubicRaster implements ICanvas{
		private var canvas:Raster;
		
		public function BezierCurveCubicRaster(canvas:Raster){
			this.canvas = canvas;
		}
		
		public function clear():void{
			this.canvas.fillRect(this.canvas.rect, 0x00000000);
		}
		
		public function draw(...coords):void{
			this.clear();
			this.canvas.cubicBezier(coords[0], coords[1], coords[2], coords[3], coords[4], coords[5], coords[6], coords[7], 0xff000000, 5);
		}
	}
}