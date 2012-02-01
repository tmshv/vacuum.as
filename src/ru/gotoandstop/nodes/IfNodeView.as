package ru.gotoandstop.nodes{
import flash.display.DisplayObject;

/**
	 *
	 * creation date: Jan 27, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class IfNodeView extends NodeView{
//		private var clip:IfNodeClip;
		
		public function IfNodeView(model:IfNode, vacuum:VacuumLayout, vo:NodeVO){
			super(vacuum, vo);
			super.model = model;
//			this.clip = new IfNodeClip();
//			super.addChild(this.clip);
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