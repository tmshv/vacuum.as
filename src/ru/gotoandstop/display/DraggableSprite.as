package ru.gotoandstop.display {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

import ru.gotoandstop.IDisposable;

[Event(name="move", type="ru.gotoandstop.display.DraggableSpriteEvent")]
/**
 * @author tmshv
 */
public class DraggableSprite extends Sprite implements IDisposable {
	private var mousePressed:Boolean;
	private var target:DisplayObject;
	private var _stage:IEventDispatcher;

	public function DraggableSprite() {
		target = this;
		super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
	}

	protected function setDragTarget(target:DisplayObject):void {
		this.target.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		this.target = target;
		this.target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
	}

	public function dispose():void {
		super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		super.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		target.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		_stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		_stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		_stage = null;
		target = null;
	}

	private function handleAddedToStage(event:Event):void {
		_stage = target.stage;
		super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		super.addEventListener(Event.REMOVED_FROM_STAGE,handleRemovedFromStage);
		_stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		_stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
	}

	private function handleRemovedFromStage(event:Event):void {
		super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		super.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		target.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		_stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		_stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
	}

	private function handleMouseDown(event:MouseEvent):void {
		super.startDrag();
		mousePressed = true;
	}

	private function handleMouseUp(event:MouseEvent):void {
		super.stopDrag();
		mousePressed = false;
	}

	protected function handleMouseMove(event:MouseEvent):void {
		if (mousePressed) {
			super.dispatchEvent(new DraggableSpriteEvent(DraggableSpriteEvent.MOVE));
		}
	}
}
}
