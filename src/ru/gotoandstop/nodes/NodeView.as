package ru.gotoandstop.nodes {
import caurina.transitions.Tweener;

import com.bit101.components.PushButton;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ru.gotoandstop.command.ICommand;

import ru.gotoandstop.display.DraggableSprite;
import ru.gotoandstop.vacuum.controllers.MouseController;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.view.VertexView;

/**
 * @author tmshv
 */
public class NodeView extends VertexView implements IVertex {
	private var dataContainer:DisplayObjectContainer;
	protected var vacuum:VacuumLayout;
	protected var vo:NodeVO;
	protected var model:INode;

	private var closeButton:PushButton;
	private var closeButtonTimeout:int;
	private var closeButtonCommand:ICommand;

	private var pos:IVertex;
	private var mover:MouseController;

	public function NodeView(vacuum:VacuumLayout, vo:NodeVO) {
		pos = new Vertex();
		super(pos, vacuum.layout, null);

		this.vacuum = vacuum;
		this.vo = vo;

		this.dataContainer = new Sprite();
		this.dataContainer.scaleX = this.vo.clipScale.x;
		this.dataContainer.scaleY = this.vo.clipScale.y;
		super.addChild(this.dataContainer);

		closeButton = new PushButton(null, 0, -18, 'X');
		closeButton.addEventListener(MouseEvent.CLICK, handleClickClose);
		closeButton.alpha = 0;
		closeButton.width = 16;
		closeButton.height = 16;
		super.addChild(closeButton);

		super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		super.addEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver);
		super.addEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut);
	}

	protected function setDragTarget(target:DisplayObject):void {
		mover.setTarget(target);
	}

	private function handleAddedToStage(event:Event):void {
		mover = new MouseController(this);

		super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		super.addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
	}

	private function handleRemovedFromStage(event:Event):void {
		super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		super.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
	}

	override public function get x():Number {
		return pos.x;
	}

	override public function set x(value:Number):void {
		pos.x = value;
	}

	override public function get y():Number {
		return pos.y;
	}

	override public function set y(value:Number):void {
		pos.y = value;
	}

	override public function dispose():void {
		mover.dispose();
		Tweener.removeTweens(closeButton);
		clearTimeout(closeButtonTimeout);
		closeButton.removeEventListener(MouseEvent.CLICK, handleClickClose);
		dataContainer.removeEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver);
		super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		super.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		super.dispose();
	}

	private function showClose():void {
		closeButton.mouseEnabled = true;
		Tweener.removeTweens(closeButton);
		Tweener.addTween(closeButton, {alpha:1, time:0.3});
	}

	private function hideClose():void {
		closeButton.mouseEnabled = false;
		Tweener.removeTweens(closeButton);
		Tweener.addTween(closeButton, {alpha:0, time:0.5});
	}

	public function setCloseCommand(cmd:ICommand):void {
		closeButtonCommand = cmd;
	}

	private function handleMouseOver(event:MouseEvent):void {
		clearTimeout(closeButtonTimeout);
		closeButtonTimeout = setTimeout(showClose, 500);
	}

	private function handleMouseOut(event:MouseEvent):void {
		clearTimeout(closeButtonTimeout);
		closeButtonTimeout = setTimeout(hideClose, 300);
	}

	public function getMarkers():Vector.<Object> {
		var result:Vector.<Object> = new Vector.<Object>;
		return result;
	}

	public override function addChild(child:DisplayObject):DisplayObject {
		return this.dataContainer.addChild(child);
	}

	public function getPoint(name:String):PortPoint {
		//			for each (var point:ActivePoint in this.points){
		//				if (point.name == name){
		//					return point;
		//				}
		//			}
		return null;
	}

	//	protected override function handleMouseMove(event:MouseEvent):void {
	//		this.update();
	//		super.handleMouseMove(event);
	//	}

	//	public function update():void {
	//		super.dispatchEvent(new Event(Event.CHANGE));
	//	}
	//
	//	public function toPoint():Point {
	//		return new Point();
	//	}

	//	public function setCoord(x:Number, y:Number):void {
	//		super.x = x;
	//		super.y = y;
	//
	//		this.update();
	//	}

	//	public function getCoord(params:Object = null):Point {
	//		return new Point(super.x, super.y);
	//	}

	private function handleClickClose(event:Event):void {
		if (closeButtonCommand) closeButtonCommand.execute();
	}
}
}