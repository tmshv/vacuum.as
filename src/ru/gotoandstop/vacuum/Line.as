package ru.gotoandstop.vacuum{
	import ru.gotoandstop.vacuum.core.IVertex;
	
	/**
	 *
	 * Creation date: May 1, 2011 (4:26:22 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Line{
		public var first:IVertex;
		public var second:IVertex;
		
		public function Line(first:IVertex, second:IVertex){
			this.first = first;
			this.second = second;
		}
	}
}