/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 03.02.12
 * Time: 18:20
 *
 */
package ru.gotoandstop.nodes.datatypes {
import com.bit101.components.HSlider;
import com.bit101.components.Panel;
import com.bit101.components.Slider;

import ru.gotoandstop.nodes.NodeVO;
import ru.gotoandstop.nodes.core.Node;
import ru.gotoandstop.nodes.VacuumLayout;

public class RangeNode extends Node{
	private var num:Slider;
	public function RangeNode(model:ValueObject, vacuum:VacuumLayout, vo:NodeVO) {
		super(vacuum, vo);
		super._model = model;

		var h:Panel = new Panel();
		h.height = 35;
		super.addChild(h);
		//			super.setDragTarget(h);

		num = new HSlider(null, 10 ,10);
		super.addChild(num);

//		var value:NumberValue = model.getValue('value');
//		value.addEventListener(Event.CHANGE, this.handleChange);
//		num.value = value.value;
//		this.currentValue = num.value;
	}
}
}
