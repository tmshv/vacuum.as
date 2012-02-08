/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 05.02.12
 * Time: 20:42
 *
 */
package ru.gotoandstop.nodes.datatypes {
import ru.gotoandstop.values.StringValue;

public class StringObject extends ValueObject{
	public function StringObject() {
		super(new StringValue());
	}
}
}
