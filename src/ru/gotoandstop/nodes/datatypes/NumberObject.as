/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 06.02.12
 * Time: 1:01
 *
 */
package ru.gotoandstop.nodes.datatypes {
import ru.gotoandstop.values.NumberValue;

public class NumberObject extends ValueObject{
	public function NumberObject() {
		super(new NumberValue())
	}
}
}
