package ru.gotoandstop.vacuum.controllers{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ru.gotoandstop.math.Calculate;
	import ru.gotoandstop.vacuum.Layout;
	import ru.gotoandstop.vacuum.Spline;
	import ru.gotoandstop.vacuum.SplineView;
	import ru.gotoandstop.vacuum.core.IDisposable;
	import ru.gotoandstop.vacuum.core.Vertex;
	import ru.gotoandstop.vacuum.view.RectIcon;
	import ru.gotoandstop.vacuum.view.VertexView;
	
	/**
	 *
	 * Creation date: Jul 24, 2011
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class DOTransformController extends EventDispatcher implements IDisposable{
		private var disposables:Vector.<IDisposable>;
	
		public var layout:Layout;
		
		private var vac:DisplayObjectContainer;
		private var vertexContainer:DisplayObjectContainer;
		private var splineContainer:DisplayObjectContainer;
		
		private var _target:DisplayObject;
		public function get target():DisplayObject{
			return this._target;
		}
		
		public var topleft:VertexView;
		public var top:VertexView;
		public var topright:VertexView;
		public var right:VertexView;
		public var bottomright:VertexView;
		public var bottom:VertexView;
		public var bottomleft:VertexView;
		public var left:VertexView;
		public var center:VertexView;
		
		private var idealWidth:Number;
		private var idealHeight:Number;
		
		public var scaleX:Number;
		public var scaleY:Number;
		public var rotation:Number;
		public var topLeftX:Number;
		public var topLeftY:Number;
		
		private var currentVertexDependencySet:IDependencySet;
		private var layoutCenter:Vertex;
		private var frameComplete:Boolean;
		
		public function DOTransformController(target:DisplayObject, vacuumContainer:DisplayObjectContainer, layoutCenter:Vertex, width:Number, height:Number){
			super();
			this.layoutCenter = layoutCenter;
			this.idealWidth = width;
			this.idealHeight = height;
			
			this.disposables = new Vector.<IDisposable>();
			this.layout = new Layout();
			
			this.vac = vacuumContainer;
			this._target = target;
			
			this.vertexContainer = new Sprite();
			this.splineContainer = new Sprite();
			this.vac.addChild(this.splineContainer);
			this.vac.addChild(this.vertexContainer);
			
			/*
			1--2--3
			|     |
			4     5
			|     |
			6--7--8
			*/
			
			//defining corner values
			var tx:Number = this.target.x + this.layoutCenter.x;
			var ty:Number = this.target.y + this.layoutCenter.y;
			
			var tw:Number = this.idealWidth * this.target.scaleX;
			var th:Number = this.idealHeight * this.target.scaleY;
			var tw2:Number = tw/2;
			var th2:Number = th/2;
			
			//defining transformed coods
			var angle:Number = this.target.rotation * (Math.PI/180);
			var p1:Point = new Point(tx, ty);
			var p2:Point = this.getRotatedPoint(p1, new Point(tx+tw2, ty), angle);
			var p3:Point = this.getRotatedPoint(p1, new Point(tx+tw, ty), angle);
			var p4:Point = this.getRotatedPoint(p1, new Point(tx, ty+th2), angle);
			var p5:Point = this.getRotatedPoint(p1, new Point(tx+tw, ty+th2), angle);
			var p6:Point = this.getRotatedPoint(p1, new Point(tx, ty+th), angle);
			var p7:Point = this.getRotatedPoint(p1, new Point(tx+tw2, ty+th), angle);
			var p8:Point = this.getRotatedPoint(p1, new Point(tx+tw, ty+th), angle);
			var center_coord:Point = this.getRotatedPoint(p1, new Point(tx+tw2, ty+th2), angle);
			
//			p1 = this.target.localToGlobal(p1);
//			p2 = this.target.localToGlobal(p2);
//			p3 = this.target.localToGlobal(p3);
//			p4 = this.target.localToGlobal(p4);
//			p5 = this.target.localToGlobal(p5);
//			p6 = this.target.localToGlobal(p6);
//			p7 = this.target.localToGlobal(p7);
//			p8 = this.target.localToGlobal(p8);
			
			//creating vertices
			var c1:VertexView = this.addPoint(p1.x, p1.y);
			var c2:VertexView = this.addPoint(p2.x, p2.y);
			var c3:VertexView = this.addPoint(p3.x, p3.y);
			var c4:VertexView = this.addPoint(p4.x, p4.y);
			var c5:VertexView = this.addPoint(p5.x, p5.y);
			var c6:VertexView = this.addPoint(p6.x, p6.y);
			var c7:VertexView = this.addPoint(p7.x, p7.y);
			var c8:VertexView = this.addPoint(p8.x, p8.y);
			var center:VertexView = this.addPoint(center_coord.x, center_coord.y);
			
			c1.vertex.addEventListener(Event.CHANGE, this.handleCornerVertexChanged);
			c2.vertex.addEventListener(Event.CHANGE, this.handleCornerVertexChanged);
			c3.vertex.addEventListener(Event.CHANGE, this.handleCornerVertexChanged);
			c4.vertex.addEventListener(Event.CHANGE, this.handleCornerVertexChanged);
			c5.vertex.addEventListener(Event.CHANGE, this.handleCornerVertexChanged);
			c6.vertex.addEventListener(Event.CHANGE, this.handleCornerVertexChanged);
			c7.vertex.addEventListener(Event.CHANGE, this.handleCornerVertexChanged);
			c8.vertex.addEventListener(Event.CHANGE, this.handleCornerVertexChanged);
			
			var parental:ParentVertexController = new ParentVertexController(this.layoutCenter);
			parental.add(c1.vertex);
			parental.add(c2.vertex);
			parental.add(c3.vertex);
			parental.add(c4.vertex);
			parental.add(c5.vertex);
			parental.add(c6.vertex);
			parental.add(c7.vertex);
			parental.add(c8.vertex);
			parental.add(center.vertex);
			this.disposables.push(parental);
			
			this.topleft = c1;
			this.top = c2;
			this.topright = c3;
			this.right = c5;
			this.bottomright = c8;
			this.bottom = c7;
			this.bottomleft = c6;
			this.left = c4;
			this.center = center;
			
			//creating spline
			var spline:Spline = new Spline();
			spline.closed = true;
			spline.addVertex(c1.vertex);
			spline.addVertex(c2.vertex);
			spline.addVertex(c3.vertex);
			spline.addVertex(c5.vertex);
			spline.addVertex(c8.vertex);
			spline.addVertex(c7.vertex);
			spline.addVertex(c6.vertex);
			spline.addVertex(c4.vertex);
			var line:SplineView = new SplineView(spline);
			this.splineContainer.addChild(line);
			this.disposables.push(spline);
			this.disposables.push(line);
			
			this.defineController(new NineVertexRectangleSet2());
			
			this.target.addEventListener(Event.EXIT_FRAME, this.handleExitFrame);
		}
		
		/**
		 * Создать зависимости между точками в соответствии с set 
		 * @param set
		 * 
		 */
		public function defineController(set:IDependencySet):void{
			var v:Vector.<VertexView> = new Vector.<VertexView>();
			v.push(this.topleft, this.top, this.topright);
			v.push(this.left, this.right);
			v.push(this.bottomleft, this.bottom, this.bottomright);
			v.push(this.center);
			set.createDependencies(v);
			
			this.currentVertexDependencySet = set;
		}
		
		private function handleCornerVertexChanged(event:Event):void{
			this.frameComplete = false;
		}
		
		public function updateLocation():void{
			/*
			1--2--3
			|     |
			4     5
			|     |
			6--7--8
			*/
			
			//defining corner values
			var tp:Point = this.target.localToGlobal(new Point());
			var tx:Number = tp.x;
			var ty:Number = tp.y;
			var tw:Number = this.idealWidth * this.target.scaleX * this.target.parent.scaleX;
			var th:Number = this.idealHeight * this.target.scaleY * this.target.parent.scaleY;
			var tw2:Number = tw/2;
			var th2:Number = th/2;
			
			//defining transformed coods
			var angle:Number = this.target.rotation * (Math.PI/180);
			var p1:Point = new Point(tx, ty);
			var p2:Point = this.getRotatedPoint(p1, new Point(tx+tw2, ty), angle);
			var p3:Point = this.getRotatedPoint(p1, new Point(tx+tw, ty), angle);
			var p4:Point = this.getRotatedPoint(p1, new Point(tx, ty+th2), angle);
			var p5:Point = this.getRotatedPoint(p1, new Point(tx+tw, ty+th2), angle);
			var p6:Point = this.getRotatedPoint(p1, new Point(tx, ty+th), angle);
			var p7:Point = this.getRotatedPoint(p1, new Point(tx+tw2, ty+th), angle);
			var p8:Point = this.getRotatedPoint(p1, new Point(tx+tw, ty+th), angle);
			var center_coord:Point = this.getRotatedPoint(p1, new Point(tx+tw2, ty+th2), angle);
			
			this.topleft.vertex.x = p1.x;
			this.topleft.vertex.y = p1.y;
			
//			this.top.vertex.x = p2.x;
//			this.top.vertex.y = p2.y;
			
//			var c1:VertexView = this.addPoint(p1.x, p1.y);
//			var c2:VertexView = this.addPoint(p2.x, p2.y);
//			var c3:VertexView = this.addPoint(p3.x, p3.y);
//			var c4:VertexView = this.addPoint(p4.x, p4.y);
//			var c5:VertexView = this.addPoint(p5.x, p5.y);
//			var c6:VertexView = this.addPoint(p6.x, p6.y);
//			var c7:VertexView = this.addPoint(p7.x, p7.y);
//			var c8:VertexView = this.addPoint(p8.x, p8.y);
			this.center.vertex.x = center_coord.x;
			this.center.vertex.y = center_coord.y;
		}
		
		public function startMove():void{
			//this.currentVertexDependencySet.dispose();
			
			var mover:MouseController = this.topleft.getController('move');
			mover.startMove();
			
			mover = this.top.getController('move');
			mover.startMove();
			
			mover = this.topright.getController('move');
			mover.startMove();
			
			mover = this.right.getController('move');
			mover.startMove();
			
			mover = this.bottomright.getController('move');
			mover.startMove();
			
			mover = this.bottom.getController('move');
			mover.startMove();
			
			mover = this.bottomleft.getController('move');
			mover.startMove();
			
			mover = this.left.getController('move');
			mover.startMove();
			
			mover = this.center.getController('move');
			mover.startMove();
		}
		
		/**
		 * Отписаться от всех событий, отчистить детей, приготовиться к GC
		 * 
		 */
		public function dispose():void{
			for each(var item:IDisposable in this.disposables){
				item.dispose();
			}
			
			this.vac.removeChild(this.splineContainer);
			this.vac.removeChild(this.vertexContainer);
			this.splineContainer = null;
			this.vertexContainer = null;
			
			this.target.removeEventListener(Event.EXIT_FRAME, this.handleExitFrame);
		}
		
		private function handleExitFrame(event:Event):void{
			if(!this.frameComplete){
				this.topLeftX = this.topleft.x - this.layoutCenter.x;
				this.topLeftY = this.topleft.y - this.layoutCenter.y;
				
				var top_left:Point = this.topleft.vertex.toPoint();
				var top_right:Point = this.topright.vertex.toPoint();
				var bottom_left:Point = this.bottomleft.vertex.toPoint();
				
				var width:Number = Calculate.distance(top_left, top_right);
				var height:Number = Calculate.distance(top_left, bottom_left);
				
				this.rotation = Calculate.degree(top_left, top_right);
				this.scaleX = width / this.idealWidth;
				this.scaleY = height / this.idealHeight;
				
				this.target.scaleX = this.scaleX;
				this.target.scaleY = this.scaleY;
				this.target.x = this.topLeftX;
				this.target.y = this.topLeftY;
				this.target.rotation = this.rotation;
			}

			this.frameComplete = true;
		}
		
		private function addPoint(x:Number, y:Number):VertexView{
			var vertex:Vertex = new Vertex(x, y);
			var view:VertexView = new VertexView(vertex, this.layout, new RectIcon(0xff000000, 0xffffffff));
			this.vertexContainer.addChild(view);
			var ac:MouseController = new MouseController(view);
			view.addController(ac, 'move');
			
			this.disposables.push(view);
			this.disposables.push(ac);
			return view;
		}
		
		/**
		 * Подсчитывает координату точки coord, повернутой относительно center на angle радиан
		 * @param center
		 * @param coord
		 * @param angle
		 * @return 
		 * 
		 */
		private function getRotatedPoint(center:Point, coord:Point, angle:Number):Point{
			var radius:Number = Calculate.distance(center, coord);
			angle += Calculate.angle(center, coord);
			var new_coord:Point = new Point();
			new_coord.x = center.x + Math.cos(angle) * radius;
			new_coord.y = center.y + Math.sin(angle) * radius;
			return new_coord;
		}
	}
}