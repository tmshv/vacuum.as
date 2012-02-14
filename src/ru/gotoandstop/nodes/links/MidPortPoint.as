package ru.gotoandstop.nodes.links {
import flash.events.Event;

import ru.gotoandstop.IDirectionalVertex;
import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.links.IPort;
import ru.gotoandstop.nodes.links.IPort;
import ru.gotoandstop.nodes.links.IPort;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
 * ...
 * @author Roman Timashev
 */
public class MidPortPoint extends Vertex{
	private var _target:IPort;
	private var _target2:IPort;
	private var ratio:Number;
	private var min:Number;
	private var max:Number;

	public function MidPortPoint(target:IPort, target2:IPort, interpolationValue:Number = 0.5, minimalInterpolationValue:Number = 10, maximalInterpolationValue:Number = 100) {
		super();
		_target = target;
		_target2 = target2;
		ratio = interpolationValue;
		min = minimalInterpolationValue;
		max = maximalInterpolationValue;

		_target.addEventListener(Event.CHANGE, calc);
		_target2.addEventListener(Event.CHANGE, calc);
		calc();
	}

	public function dispose():void {
		if (_target) _target.removeEventListener(Event.CHANGE, calc);
		if (_target2) _target2.removeEventListener(Event.CHANGE, calc);
		_target = null;
		_target2 = null;
	}

	private function calc(event:Event = null):void {
		var x:Number;
		var y:Number;

		if (_target.direction == 'left') {
			x = (_target2.x - _target.x) * ratio;
			x = Math.abs(x);
			x = Math.min(x, max);
			x = Math.max(x, min);
			x = _target.x - x;
			y = _target.y;
		} else if (_target.direction == 'right') {
			x = (_target2.x - _target.x) * ratio;
			x = Math.abs(x);
			x = Math.min(x, max);
			x = Math.max(x, min);
			x = _target.x + x;
			y = _target.y;
		} else if (_target.direction == 'up') {
			x = _target.x;
			y = (_target2.y - _target.y) * ratio;
			y = Math.abs(y);
			y = Math.min(y, max);
			y = Math.max(y, min);
			y = _target.y - y;
		} else if (_target.direction == 'down') {
			x = _target.x;
			y = (_target2.y - _target.y) * ratio;
			y = Math.abs(y);
			y = Math.min(y, max);
			y = Math.max(y, min);
			y = _target.y + y;
		} else {
			x = _target.x;
			y = _target.y;
		}

		super.setCoord(x, y);
	}
}
}