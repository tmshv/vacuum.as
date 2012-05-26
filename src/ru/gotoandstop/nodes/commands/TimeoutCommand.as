/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/16/12
 * Time: 4:50 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.commands {
import flash.utils.setTimeout;

import ru.gotoandstop.command.ICommand;

public class TimeoutCommand implements ICommand {
    private var _delay:uint;
    private var _command:ICommand;

    public function TimeoutCommand(delay:uint, command:ICommand) {
        _delay = delay;
        _command = command;
    }

    public function execute(data:Object = null):void {
        setTimeout(_command.execute, _delay);
    }
}
}
