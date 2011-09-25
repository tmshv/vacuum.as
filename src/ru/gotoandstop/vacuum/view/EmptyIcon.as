package ru.gotoandstop.vacuum.view{
	
	/**
	 *
	 * Creation date: Jun 2, 2011 (1:34:49 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class EmptyIcon extends VertexIcon{
		public function EmptyIcon(draw:Boolean=false){
			super();
			if(draw) super.drawInvisibleCircle(3);
		}
	}
}