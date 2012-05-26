/**
 * Created with IntelliJ IDEA.
 * User: tmshv
 * Date: 4/10/12
 * Time: 2:55 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.validate {
import ru.gotoandstop.utils.Convert;

public class BooleanValidator implements IInputValidator{
    public function BooleanValidator() {
    }

    public function validate(input:Object):Object {
        var text:String = input.toString();
        return Convert.stringToBoolean(text, true);
    }
}
}
