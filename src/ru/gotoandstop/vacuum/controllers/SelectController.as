package ru.gotoandstop.vacuum.controllers{
import flash.events.EventDispatcher;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.ui.ISelectable;

/**
	 *
	 * Creation date: Jun 3, 2011 (7:58:22 AM)
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public class SelectController extends EventDispatcher implements IDisposable{
		private var items:Vector.<ISelectable>;
		
		public function SelectController(){
			super();
			this.items = new Vector.<ISelectable>();
		}
		
		public function dispose():void{
			this.clear();
		}
		
		public function add(item:ISelectable):void{
			this.clear();
			this.pushAndSelect(item);
		}
		
		public function addItems(items:Vector.<ISelectable>):void{
			this.clear();
			for each(var item:ISelectable in items){
				this.pushAndSelect(item);
			}
		}
		
		private function pushAndSelect(item:ISelectable):void{
			this.items.push(item);
			item.select();
		}
		
		public function clear():void{
			for each(var v:ISelectable in this.items){
				v.deselect();
			}
			if(this.items.length){
				this.items.length = 0;// = new Vector.<ISelectable>();	
			}
		}
	}
}