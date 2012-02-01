package ru.gotoandstop.nodes.commands{
import com.junkbyte.console.Cc;

import ru.gotoandstop.command.ICommand;

/**
	 *
	 * creation date: Jan 27, 2012
	 * @author Roman Timashev (roman@tmshv.ru)
	 **/
	public class PrintCommand implements ICommand{
		private var message:String;
		public function PrintCommand(message:String){
			this.message = message;
		}
		
		public function execute():void{
			trace(this.message);
			Cc.log(this.message);
		}
	}
}