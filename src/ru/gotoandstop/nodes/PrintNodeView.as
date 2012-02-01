package ru.gotoandstop.nodes{
import flash.display.DisplayObject;
import flash.events.Event;
import flash.text.TextField;

/**
	 *
	 * creation date: Jan 27, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class PrintNodeView extends NodeView{
//		private var clip:PrintNodeClip;
		private var msg:String;
		private var printer:PrintNode;
		
		public function PrintNodeView(model:PrintNode, vacuum:VacuumLayout, vo:NodeVO){
			super(vacuum, vo);
			super.model = model;
			this.printer = model;
//			this.clip = new PrintNodeClip();
//			super.addChild(this.clip);
//
//			this.msg = this.printer.msg;
//			this.clip.msg.text = this.msg;
//
////			this.clip.numberValue.addEventListener(FocusEvent.FOCUS_IN, this.handleFocusIn);
////			this.clip.numberValue.addEventListener(FocusEvent.FOCUS_OUT, this.handleFocusOut);
//			this.clip.msg.addEventListener(Event.CHANGE, this.handleTextChange);
		}
		
		private function handleTextChange(event:Event):void{
			var field:TextField = event.target as TextField;
			this.printer.setMessage(field.text);	
		}
		
//		public override function getPointMarkers():Vector.<DisplayObject>{
//			var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
//			for(var i:uint; i<this.clip.numChildren; i++){
//				var p:DisplayObject = this.clip.getChildAt(i);
//				var p_name:String = p.name;
//				var excluded:Boolean = false;
//				var exclude:Vector.<Object> = super.vo.exclude;
//				for each (var item:Object in exclude){
//					if (p_name.match(item)){
//						excluded = true;
//						break;
//					}
//				}
//
//				if (!excluded){
//					result.push(p);
//				}
//			}
//			return result;
//		}
	}
}