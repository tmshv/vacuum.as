/**
 *
 * User: tmshv
 * Date: 4/28/12
 * Time: 4:29 PM
 */
package ru.gotoandstop.nodes.markers {
import com.bit101.components.HRangeSlider;
import com.bit101.components.RangeSlider;

import ru.gotoandstop.nodes.core.NodeField;

public class RangeMarker extends NodeField{
    public function RangeMarker(key:String, object:Object, index:int) {
        super(key, object, index);

        var range:RangeSlider = new HRangeSlider();
        range.lowValue = object.low;
        range.highValue = object.high;
        super.addChild(range);
    }
}
}
