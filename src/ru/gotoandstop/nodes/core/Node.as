package ru.gotoandstop.nodes.core {
import caurina.transitions.Tweener;

import com.bit101.components.PushButton;

import flash.display.DisplayObject;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.RelativeVertex;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.links.PortPoint;
import ru.gotoandstop.ui.ISelectable;
import ru.gotoandstop.vacuum.controllers.MouseController;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.ModifiableVertex;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.view.VertexView;

/**
 * @author tmshv
 */
public class Node extends VertexView implements IVertex, INode, ISelectable {
	private var dataContainer:DisplayObjectContainer;
	protected var vacuum:VacuumLayout;
	protected var _model:INode;
	public function get model():INode {
		return _model;
	}

	private var closeButton:PushButton;
	private var closeButtonTimeout:int;

	private var closeButtonCommand:ICommand;
	internal var pos:ModifiableVertex;
	private var mover:MouseController;

    private var _selected:Boolean;

	private var actives:Object;
    
    protected var _selectedShape:DisplayObject;

	public function Node(vacuum:VacuumLayout, model:INode) {
		pos = new ModifiableVertex();
		super(pos, vacuum.layout, null);
        _model = model;
        _model.addEventListener(Event.CHANGE, super.dispatchEvent);
		mover = new MouseController(this);
		actives = new Object();
		this.vacuum = vacuum;
		this.dataContainer = new Sprite();
		super.addChild(this.dataContainer);

		closeButton = new PushButton(null, 0, -18, 'X');
		closeButton.addEventListener(MouseEvent.CLICK, handleClickClose);
		closeButton.alpha = 0;
		closeButton.width = 16;
		closeButton.height = 16;
		super.addChild(closeButton);

		super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		super.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
		super.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);

        draw();
        createPoints(getMarkers());
	}

    protected function draw():void{

    }

	override public function dispose():void {
		mover.dispose();
		Tweener.removeTweens(closeButton);
		clearTimeout(closeButtonTimeout);
		closeButton.removeEventListener(MouseEvent.CLICK, handleClickClose);
		dataContainer.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
		super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		super.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		super.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
		super.removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
        _model.removeEventListener(Event.CHANGE, super.dispatchEvent);
        _model.dispose();
        _model = null;
		super.dispose();
	}

	protected function createPoints(markers:Vector.<Object>):void {
		var scale_x:Number = 1;
		var scale_y:Number = 1;

		for each(var p:Object in markers) {
			var prop:String = p.param;
			var type:String = p.type;
			var x:Number = p.x * scale_x;
			var y:Number = p.y * scale_y;

			x /= vacuum.layout.scale.value;
			y /= vacuum.layout.scale.value;

			addPort(x, y, prop, type, p.dir);
		}
	}

	protected function addPort(x:Number, y:Number, property:String, type:String, direction:String):void {
		var xy:IVertex = new Vertex(x, y);
		var rel:IVertex = new RelativeVertex(this, xy);

		var point:PortPoint = new PortPoint(rel, vacuum.layout, _model, property, type, direction);
		vacuum.showPort(point);

		actives[property] = point;
	}

	public function getPoint(property:String):PortPoint {
		return actives[property];
	}

	override public function get name():String {
		return _model.name;
	}

	override public function set name(value:String):void {
		_model.name = value;
	}

	protected function setDragTarget(target:DisplayObject):void {
		mover.setTarget(target);
	}

	private function handleAddedToStage(event:Event):void {
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
		return dataContainer.addChild(child);
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

	public function get type():String {
		return model.type;
	}

	public function set type(value:String):void {
		model.type = value;
	}

	public function getKeyValue(key:String):* {
		return model.getKeyValue(key);
	}

	public function setKeyValue(key:String, value:*):void {
		model.setKeyValue(key, value);
	}

	public function getParams():Vector.<String> {
		return model.getParams();
	}

    public function select():void {
        _selected = true;
        if(_selectedShape) {
            _selectedShape.filters = [new GlowFilter(0x0000ff, 0.3, 2, 2, 255)];
        }
    }

    public function deselect():void {
        _selected = false;
        if(_selectedShape) {
            _selectedShape.filters = [];
        }
    }

    public function get isSelected():Boolean {
        return _selected;
    }
}
}