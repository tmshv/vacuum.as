package ru.gotoandstop.vacuum{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import ru.gotoandstop.vacuum.view.VertexView;
	
	/**
	 *
	 * creation date: Nov 25, 2011
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class ShowVertexInfo extends EventDispatcher{
		private var text:Text;
		private var dot:VertexView;
		private var info:String;
		private var over:Boolean;
		
		public function ShowVertexInfo(container:DisplayObjectContainer, dot:VertexView, info:String){
			super();
			this.dot = dot;
			this.dot.vertex.addEventListener(Event.CHANGE, this.handleVertexChanged);
			this.dot.addEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver);
			this.dot.addEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut);
			this.dot.addEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			//			this.dot.active.addEventListener(Event.CHANGE, this.handleDotActivityChanged);
			this.info = info;
			this.text = new Text();
			this.text.visible = false;
			container.addChild(this.text);
			
			this.update();
		}
		
		private function handleRemovedFromStage(event:Event):void{
			this.dot.vertex.removeEventListener(Event.CHANGE, this.handleVertexChanged);
			this.dot.removeEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver);
			this.dot.removeEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut);
			this.dot.removeEventListener(Event.REMOVED_FROM_STAGE, this.handleRemovedFromStage);
			//			this.dot.active.removeEventListener(Event.CHANGE, this.handleDotActivityChanged);
		}
		
		private function handleMouseOver(event:MouseEvent):void{
			this.over = true;
			this.text.visible = true;
		}
		
		private function handleMouseOut(event:MouseEvent):void{
			this.over = false;
			this.text.visible = false;
			//			this.text.visible = this.dot.active.value;
		}
		
		private function handleVertexChanged(event:Event):void{
			this.update();
		}
		
		private function handleDotActivityChanged(event:Event):void{
			//			this.text.visible = this.dot.active.value || this.over;
		}
		
		private function update():void{
			this.text.x = this.dot.x;
			this.text.y = this.dot.y;
			this.text.text = info;
		}
	}
}