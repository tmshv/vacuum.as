package ru.gotoandstop.nodes
{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

import ru.gotoandstop.nodes.datatypes.INode;

/**
	 * ...
	 * @author Roman Timashev
	 */
	public class CodeLineNodeView extends NodeView 
	{
		private var markers:Vector.<DisplayObject>;
		
		public function CodeLineNodeView(model:INode, code:String, vacuum:VacuumLayout, vo:NodeVO)
		{
			super(vacuum, vo);
			super._model = model;
			
			var props:Vector.<String> = model.getParams();
			var x:Number = 0;
			this.markers = new Vector.<DisplayObject>();
			for each(var p:String in props) {
				var t:Array = p.match(/(in|out) ([\w\d]+) ([\w\d]+)/);
				var type:String = t[1];
				var data:String = t[2];
				var param:String = t[3];
				var s:DisplayObject = new Sprite();
				s.name = param;
				s.x = x * 30;
				s.y = 0;
				super.addChild(s);
				this.markers.push(s);
				x ++;
			}
			
			var text:TextField = new TextField();
			text.autoSize = 'left';
			text.border = true;
			text.defaultTextFormat = new TextFormat('_typewriter', 12);
			text.text = code;
			text.selectable = false;
			super.addChild(text);
		}
		
//		public override function getPointMarkers():Vector.<DisplayObject>{
//			return this.markers;
//		}
	}

}