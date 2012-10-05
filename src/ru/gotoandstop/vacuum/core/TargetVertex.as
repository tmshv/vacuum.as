/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 1/31/12
 * Time: 11:03 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.vacuum.core {
import flash.events.Event;

public class TargetVertex extends ModifiableVertex implements ITargetVertex{
	protected var _target:IVertex;
	public function get target():IVertex {
		return _target;
	}

	public function TargetVertex(target:IVertex=null) {
		if(target) setTarget(target);
	}

	public function setTarget(vertex:IVertex):void {
		dispose();
		_target = vertex;
		if(_target) _target.onChange(calc);
		calc();
	}

	public function dispose():void {
		if(_target) _target.offChange(calc);
	}
	
	protected function calc(event:Event=null):void {
		setCoord(_target.x,  _target.y);
	}
}
}