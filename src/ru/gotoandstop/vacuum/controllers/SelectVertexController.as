package ru.gotoandstop.vacuum.controllers{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import ru.gotoandstop.vacuum.ISelectable;
	import ru.gotoandstop.vacuum.view.RectIcon;
	import ru.gotoandstop.vacuum.view.VertexIcon;
	import ru.gotoandstop.vacuum.view.VertexView;
	import ru.gotoandstop.values.BooleanValue;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 *
	 * Creation date: Jun 3, 2011 (2:29:34 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SelectVertexController extends EventDispatcher implements ISelectable{
		private var _selected:BooleanValue;
		private function get selected():BooleanValue{
			return this._selected;
		}
		
		private var vertex:VertexView;
		private var defauldIcon:VertexIcon;
		
		public function SelectVertexController(vertex:VertexView){
			super();
			this.vertex = vertex;
			this.vertex.addEventListener(MouseEvent.CLICK, this.handleClick);
			this.defauldIcon = vertex.icon;
			
			this._selected = new BooleanValue();
			this._selected.addEventListener(Event.CHANGE, this.handleValueChange);
		}
		
		public function isSelected():Boolean{
			return this.selected.value;
		}
		
		public function select():void{
			this.selected.value = true;
		}
		
		public function deselect():void{
			this.selected.value = false;
		}
		
		private function handleClick(event:MouseEvent):void{
//			this.selected.value = !this.selected.value;
		}
		
		private function handleValueChange(event:Event):void{
			if(this.selected.value){
				this.vertex.setIcon(new RectIcon(0xff000000, 0xff000000));
			}else{
				this.vertex.setIcon(this.defauldIcon);
			}
			super.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}