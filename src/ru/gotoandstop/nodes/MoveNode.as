package ru.gotoandstop.nodes{
import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.vacuum.core.IVertex;

/**
	 * @author tmshv
	 */
	public class MoveNode extends NodeModel implements ICommand{
		private var _destination:IVertex;
		public function get destination():IVertex{
			return this._destination;
		}
		public function set destination(value:IVertex):void{
			this._destination = value;
		}
		
		private var _complete:ICommand;
		public function get complete():ICommand{
			return this._complete;
		}
		public function set complete(value:ICommand):void{
			this._complete = value;
		}
		
		public function MoveNode(){
			super();
		}
		
		public override function setValue(key:String, value:*):void{
			super.setValue(key, value);
//			if(key == 'complete'){
//				this.complete =
//			}
		}
		
		public function execute():void{
			
		}
	}
}
