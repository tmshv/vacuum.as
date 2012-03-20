/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/20/12
 * Time: 11:38 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.datatypes {
import ru.gotoandstop.values.BooleanValue;

public class BooleanObject extends ValueObject{
    public function BooleanObject() {
        super(new BooleanValue());
    }
}
}
