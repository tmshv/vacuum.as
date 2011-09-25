package ru.gotoandstop.vacuum{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	/**
	 *
	 * Creation date: May 2, 2011 (12:15:40 PM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class Text extends TextField{
		public function Text(){
			super();
			
			super.defaultTextFormat = new TextFormat('Courier New', 12, 0x000000);
//			super.defaultTextFormat.align = TextFormatAlign.RIGHT;
			super.autoSize = TextFieldAutoSize.LEFT;
			super.selectable = false;
			super.mouseEnabled = false;
//			super.embedFonts = false;
//			super.antiAliasType = AntiAliasType.NORMAL;
//			super.sharpness = 10;
		}
	}
}