package ru.gotoandstop.nodes {
import flash.display.DisplayObject;
import flash.events.MouseEvent;

import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.links.IPin;
import ru.gotoandstop.vacuum.controllers.MouseController;
import ru.gotoandstop.vacuum.core.Vertex;

/**
 * @author tmshv
 */
public class MouseVertex extends Vertex implements IPin{
	private var _target:DisplayObject;

	private var _direction:String;
	public function get direction():String {
		return _direction;
	}
	public function set direction(value:String):void {
		_direction = value;
	}

	public function MouseVertex() {
		super(0, 0);
	}

    public function setEventTarget(target:DisplayObject):void{
        dispose();

        _target = target;
        _target.addEventListener(MouseEvent.MOUSE_MOVE, onTargetMouseMove);
    }

	public function dispose():void {
        if(_target) _target.removeEventListener(MouseEvent.MOUSE_MOVE, onTargetMouseMove);
		_target = null;
	}

	private function onTargetMouseMove(event:MouseEvent):void {
        var coord_x:Number = event.stageX + MouseController.offset.x;
        var coord_y:Number = event.stageY + MouseController.offset.y;
		super.setCoord(coord_x, coord_y);
	}

    public function get node():INode {
        return null;
    }

    public override function toString():String {
		return super.toString() + "[mouse]";
	}

	public function get type():String {
		return "";
	}

	public function get dataType():String {
		return "";
	}

    override public function get isLocked():Boolean {
        return false;
    }
}
}
