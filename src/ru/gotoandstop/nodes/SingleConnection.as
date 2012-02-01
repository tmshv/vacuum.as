package ru.gotoandstop.nodes {
	/**
	 * @author tmshv
	 */
	public class SingleConnection {
		public var from:PortPoint;
		public var to:PortPoint;
		public var vacuumIndex:uint;
		
		public function SingleConnection(from:PortPoint, to:PortPoint, vacuumIndex:uint = 0){
			this.from = from;
			this.to = to;
			this.vacuumIndex = vacuumIndex;
		}
	}
}
