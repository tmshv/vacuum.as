package ru.gotoandstop.vacuum.core {
import flash.events.Event;

import ru.gotoandstop.vacuum.core.IVertex;

public class TargetVertex extends Vertex implements ITargetVertex{
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
		if(_target){
            _target.onChange(recalc);
            recalc();
        }
    }

	public function dispose():void {
		if(_target) _target.offChange(recalc);
	}
	
	private function recalc(event:Event=null):void {
        setCoordToYourself(target.x, target.y);
    }

    protected function setCoordToYourself(x:Number, y:Number):void{
        lock();
        super.x = x;
        super.y = y;
        unlock();
    }

    override public function setCoord(x:Number, y:Number):void {
        if(target) target.setCoord(x, y);
    }

    override public function set x(value:Number):void {
        if(target) target.x = value;
    }

    override public function set y(value:Number):void {
        if(target) target.y = value;
    }

    override public function clone():IVertex {
        return new TargetVertex(target);
    }
}
}