package ru.gotoandstop.vacuum.controllers{
	import ru.gotoandstop.IDisposable;
	import ru.gotoandstop.vacuum.view.VertexView;

	/**
	 *
	 * Creation date: Jul 29, 2011
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class NineVertexRectangleSet2 implements IDependencySet, IDisposable{
		public var topleft:VertexView;
		public var top:VertexView;
		public var topright:VertexView;
		public var right:VertexView;
		public var bottomright:VertexView;
		public var bottom:VertexView;
		public var bottomleft:VertexView;
		public var left:VertexView;
		public var center:VertexView;
		
		private var disposables:Vector.<IDisposable>;
		
		public function NineVertexRectangleSet2(){
			this.disposables = new Vector.<IDisposable>();
		}
		
		public function dispose():void{
			for each(var item:IDisposable in this.disposables){
				item.dispose();
			}
			this.disposables = null;
		}
		
		public function createDependencies(verticies:Vector.<VertexView>):void{
			/*
			1--2--3
			|     |
			4     5
			|     |
			6--7--8
			*/
			
			var c1:VertexView = verticies[0];
			var c2:VertexView = verticies[1];
			var c3:VertexView = verticies[2];
			var c4:VertexView = verticies[3];
			var c5:VertexView = verticies[4];
			var c6:VertexView = verticies[5];
			var c7:VertexView = verticies[6];
			var c8:VertexView = verticies[7];
			var center:VertexView = verticies[8];
			
			var controllers:Vector.<IDisposable> = new Vector.<IDisposable>();
			//creating controllers
			var saver:SaveAngleController = new SaveAngleController(c1, c8.vertex);
			saver.addDependencyVertex(c2.vertex);
			saver.addDependencyVertex(c3.vertex);
			saver.addDependencyVertex(c4.vertex);
			saver.addDependencyVertex(c5.vertex);
			saver.addDependencyVertex(c6.vertex);
			saver.addDependencyVertex(c7.vertex);
			saver.addDependencyVertex(center.vertex);
			controllers.push(saver);
			
			saver = new SaveAngleController(c2, c7.vertex);
			saver.addDependencyVertex(c1.vertex);
			saver.addDependencyVertex(c3.vertex);
			saver.addDependencyVertex(c4.vertex);
			saver.addDependencyVertex(c5.vertex);
			saver.addDependencyVertex(c6.vertex);
			saver.addDependencyVertex(center.vertex);
			saver.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver);
			controllers.push(saver);
			
			saver = new SaveAngleController(c3, c6.vertex);
			saver.addDependencyVertex(c2.vertex);
			saver.addDependencyVertex(c1.vertex);
			saver.addDependencyVertex(c4.vertex);
			saver.addDependencyVertex(c5.vertex);
			saver.addDependencyVertex(center.vertex);
			saver.addDependencyVertex(c7.vertex);
			saver.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver);
			controllers.push(saver);
			
			saver = new SaveAngleController(c4, c5.vertex);
			saver.addDependencyVertex(c2.vertex);
			saver.addDependencyVertex(c3.vertex);
			saver.addDependencyVertex(c1.vertex);
			saver.addDependencyVertex(center.vertex);
			saver.addDependencyVertex(c6.vertex);
			saver.addDependencyVertex(c7.vertex);
			saver.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver);
			controllers.push(saver);
			
			saver = new SaveAngleController(c5, c4.vertex);
			saver.addDependencyVertex(c2.vertex);
			saver.addDependencyVertex(c3.vertex);
			saver.addDependencyVertex(center.vertex);
			saver.addDependencyVertex(c1.vertex);
			saver.addDependencyVertex(c6.vertex);
			saver.addDependencyVertex(c7.vertex);
			saver.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver);
			controllers.push(saver);
			
			saver = new SaveAngleController(c6, c3.vertex);
			saver.addDependencyVertex(c2.vertex);
			saver.addDependencyVertex(center.vertex);
			saver.addDependencyVertex(c4.vertex);
			saver.addDependencyVertex(c5.vertex);
			saver.addDependencyVertex(c1.vertex);
			saver.addDependencyVertex(c7.vertex);
			saver.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver);
			controllers.push(saver);
			
			saver = new SaveAngleController(c7, c2.vertex);
			saver.addDependencyVertex(center.vertex);
			saver.addDependencyVertex(c3.vertex);
			saver.addDependencyVertex(c4.vertex);
			saver.addDependencyVertex(c5.vertex);
			saver.addDependencyVertex(c6.vertex);
			saver.addDependencyVertex(c1.vertex);
			saver.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver);
			controllers.push(saver);
			
			saver = new SaveAngleController(c8, c1.vertex);
			saver.addDependencyVertex(c2.vertex);
			saver.addDependencyVertex(c3.vertex);
			saver.addDependencyVertex(c4.vertex);
			saver.addDependencyVertex(c5.vertex);
			saver.addDependencyVertex(c6.vertex);
			saver.addDependencyVertex(c7.vertex);
			saver.addDependencyVertex(center.vertex);
			//			this.disposables.push(saver);
			controllers.push(saver);
			
			var saver2:SaveDistanceController = new SaveDistanceController(c1, c8.vertex);
			saver2.addDependencyVertex(c2.vertex);
			saver2.addDependencyVertex(c3.vertex);
			saver2.addDependencyVertex(c4.vertex);
			saver2.addDependencyVertex(c5.vertex);
			saver2.addDependencyVertex(c6.vertex);
			saver2.addDependencyVertex(c7.vertex);
			saver2.addDependencyVertex(center.vertex);
			//			this.disposables.push(saver2);
			controllers.push(saver2);
			
			saver2 = new SaveDistanceController(c2, c7.vertex);
			saver2.addDependencyVertex(c1.vertex);
			saver2.addDependencyVertex(c3.vertex);
			saver2.addDependencyVertex(c4.vertex);
			saver2.addDependencyVertex(c5.vertex);
			saver2.addDependencyVertex(c6.vertex);
			saver2.addDependencyVertex(center.vertex);
			saver2.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver2);
			controllers.push(saver2);
			
			saver2 = new SaveDistanceController(c3, c6.vertex);
			saver2.addDependencyVertex(c2.vertex);
			saver2.addDependencyVertex(c1.vertex);
			saver2.addDependencyVertex(c4.vertex);
			saver2.addDependencyVertex(c5.vertex);
			saver2.addDependencyVertex(center.vertex);
			saver2.addDependencyVertex(c7.vertex);
			saver2.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver2);
			controllers.push(saver2);
			
			saver2 = new SaveDistanceController(c4, c5.vertex);
			saver2.addDependencyVertex(c2.vertex);
			saver2.addDependencyVertex(c3.vertex);
			saver2.addDependencyVertex(c1.vertex);
			saver2.addDependencyVertex(center.vertex);
			saver2.addDependencyVertex(c6.vertex);
			saver2.addDependencyVertex(c7.vertex);
			saver2.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver2);
			controllers.push(saver2);
			
			saver2 = new SaveDistanceController(c5, c4.vertex);
			saver2.addDependencyVertex(c2.vertex);
			saver2.addDependencyVertex(c3.vertex);
			saver2.addDependencyVertex(center.vertex);
			saver2.addDependencyVertex(c1.vertex);
			saver2.addDependencyVertex(c6.vertex);
			saver2.addDependencyVertex(c7.vertex);
			saver2.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver2);
			controllers.push(saver2);
			
			saver2 = new SaveDistanceController(c6, c3.vertex);
			saver2.addDependencyVertex(c2.vertex);
			saver2.addDependencyVertex(center.vertex);
			saver2.addDependencyVertex(c4.vertex);
			saver2.addDependencyVertex(c5.vertex);
			saver2.addDependencyVertex(c1.vertex);
			saver2.addDependencyVertex(c7.vertex);
			saver2.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver2);
			controllers.push(saver2);
			
			saver2 = new SaveDistanceController(c7, c2.vertex);
			saver2.addDependencyVertex(center.vertex);
			saver2.addDependencyVertex(c3.vertex);
			saver2.addDependencyVertex(c4.vertex);
			saver2.addDependencyVertex(c5.vertex);
			saver2.addDependencyVertex(c6.vertex);
			saver2.addDependencyVertex(c1.vertex);
			saver2.addDependencyVertex(c8.vertex);
			//			this.disposables.push(saver2);
			controllers.push(saver2);
			
			saver2 = new SaveDistanceController(c8, c1.vertex);
			saver2.addDependencyVertex(c2.vertex);
			saver2.addDependencyVertex(c3.vertex);
			saver2.addDependencyVertex(c4.vertex);
			saver2.addDependencyVertex(c5.vertex);
			saver2.addDependencyVertex(c6.vertex);
			saver2.addDependencyVertex(c7.vertex);
			saver2.addDependencyVertex(center.vertex);
			//			this.disposables.push(saver2);
			controllers.push(saver2);
			
			this.disposables = controllers;
		}
	}
}