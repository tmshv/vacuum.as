package ru.gotoandstop.vacuum.view{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 *
	 * Creation date: Jul 26, 2011
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class DisplayElement extends Sprite{
		private var dimensionX:Number;
		private var dimensionY:Number;
		private var container:Sprite;
		
		public function DisplayElement(){
			super();
			this.dimensionX = 0;
			this.dimensionY = 0;
			
			this.container = new Sprite();
//			this.container.mouseChildren = false;
//			this.container.mouseEnabled = false;
			super.addChild(this.container);
		}
		
		public override function addChild(child:DisplayObject):DisplayObject{
			return this.container.addChild(child);
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject{
			return this.container.addChildAt(child, index);
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject{
			return this.container.removeChild(child);
		}
		
		public function setMargin(padding:uint):void{
			var padding2:uint = padding << 1;
			
			this.container.x = padding;
			this.container.y = padding;
			
			this.dimensionX += padding2;
			this.dimensionY += padding2;
		}
		
		public function setDimension(width:Number, height:Number):void{
			this.dimensionX = width;
			this.dimensionY = height;
		}
		
		public function getDimension():Rectangle{
			return new Rectangle(0, 0, this.dimensionX, this.dimensionY);
		}
	}
}