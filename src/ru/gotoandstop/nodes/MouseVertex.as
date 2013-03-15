package ru.gotoandstop.nodes {
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.gotoandstop.IDirectionalVertex;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.links.IPin;
import ru.gotoandstop.vacuum.controllers.MouseController;
import ru.gotoandstop.vacuum.core.ITargetVertex;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
 * @author tmshv
 */
public class MouseVertex extends Vertex implements IPin{
	private var target2:DisplayObject;
	private var _direction:String;
	public function get direction():String {
		return this._direction;
	}

	public function set direction(value:String):void {
		this._direction = value;
	}

	public function MouseVertex(target:DisplayObject) {
		super(target.mouseX, target.mouseY);
		this.target2 = target;
		this.target2.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
	}

	public function dispose():void {
		this.target2.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
		this.target2 = null;
	}

	private function handleMouseMove(event:MouseEvent):void {
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

	public function get target():IVertex {
		return null;
	}

	public function setTarget(vertex:IVertex):void {
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
