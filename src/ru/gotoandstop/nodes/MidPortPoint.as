package ru.gotoandstop.nodes {
import flash.events.Event;

import ru.gotoandstop.IDirectionalVertex;
import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
 * ...
 * @author Roman Timashev
 */
public class MidPortPoint extends Vertex implements IDirectionalVertex {
	private var target3:IDirectionalVertex;
	private var target2:IDirectionalVertex;
	private var ratio:Number;
	private var min:Number;
	private var max:Number;

	public function get direction():String {
		return target3.direction;
	}

	public function set direction(value:String):void {
		target3.direction = value;
	}

	public function get target():IVertex {
		return null;
	}

	public function setTarget(vertex:IVertex):void {
	}

	public function MidPortPoint(target:IDirectionalVertex, target2:IDirectionalVertex, interpolationValue:Number = 0.5, minimalInterpolationValue:Number = 10, maximalInterpolationValue:Number = 100) {
		super();
		this.target3 = target;
		this.target2 = target2;
		this.ratio = interpolationValue;
		this.min = minimalInterpolationValue;
		this.max = maximalInterpolationValue;

		this.target.addEventListener(Event.CHANGE, this.calc);
		this.target2.addEventListener(Event.CHANGE, this.calc);
		calc();
	}

	public function dispose():void {
		if (target) target.removeEventListener(Event.CHANGE, this.calc);
		if (target2) target2.removeEventListener(Event.CHANGE, this.calc);
		this.target3 = null;
		this.target2 = null;
	}

	private function calc(event:Event = null):void {
		var x:Number;
		var y:Number;

		if (target3.direction == 'left') {
			x = (target2.x - target3.x) * ratio;
			x = Math.abs(x);
			x = Math.min(x, max);
			x = Math.max(x, min);
			x = target3.x - x;
			y = target3.y;
		} else if (target3.direction == 'right') {
			x = (target2.x - target3.x) * ratio;
			x = Math.abs(x);
			x = Math.min(x, max);
			x = Math.max(x, min);
			x = target3.x + x;
			y = target3.y;
		} else if (target3.direction == 'up') {
			x = target3.x;
			y = (target2.y - target3.y) * ratio;
			y = Math.abs(y);
			y = Math.min(y, max);
			y = Math.max(y, min);
			y = target3.y - y;
		} else if (target3.direction == 'down') {
			x = target3.x;
			y = Math.abs(y);
			y = Math.min(y, max);
			y = Math.max(y, min);
			y = target3.y + y;
		} else {
			x = target3.x;
			y = target3.y;
		}

		super.setCoord(x, y);
	}

}
}