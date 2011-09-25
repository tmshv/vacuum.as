package ru.gotoandstop.vacuum{
	import ru.gotoandstop.vacuum.core.Vertex;
	
	/**
	 *
	 * Creation date: May 1, 2011 (4:26:22 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Line{
		public var first:Vertex;
		public var second:Vertex;
		
		public function Line(first:Vertex, second:Vertex){
			this.first = first;
			this.second = second;
		}
	}
}