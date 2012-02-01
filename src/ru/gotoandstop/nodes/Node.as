package ru.gotoandstop.nodes {
import flash.events.Event;

import ru.gotoandstop.mvc.BaseController;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.Vertex;

/**
 * @author tmshv
 */
public class Node extends BaseController implements INode {
	public var autoValues:String;

	public function get name():String {
		return this.model.name;
	}

	public function set name(value:String):void {
		this.model.name = value;
	}

	//		public var name:String;

	public function get type():String {
		return this.model.type;
	}

	public function getValue(key:String):* {
		return this.model.getValue(key);
	}

	public function setValue(key:String, value:*):void {
		this.model.setValue(key, value);
	}

	public function getParams():Vector.<String> {
		return this.model.getParams();
	}

	public var view:NodeView;
	//		private var _view:NodeView;
	//		public function get view():NodeView{
	//			return this._view;
	//		}

	public var model:INode;
	//		private var _model:INode;
	//		public function get model():INode{
	//			return this._model;
	//		}

	//		private var vo:NodeVO;
	public var vo:NodeVO;

	public var vacuum:VacuumLayout;

	private var actives:Object;

	public function Node() {//container:DisplayObjectContainer, vacuum:Vacuum, name:String, model:INode, view:NodeView, vo:NodeVO){
		super(null);
		actives = new Object();
	}

	public function init():void {
		model.setValue('name', name);
		model.addEventListener(Event.CHANGE, super.dispatchEvent);
		super.container.addChild(view);

		createPoints(view.getMarkers());
	}

	override public function dispose():void {
		actives = null;
		view.dispose();
		super.container.removeChild(view);
		model.removeEventListener(Event.CHANGE, super.dispatchEvent);
		super.dispose();
	}

	private function createPoints(markers:Vector.<Object>):void {
		var scale_x:Number = vo.clipScale.x;
		var scale_y:Number = vo.clipScale.y;

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

	public function getValueType(valueName:String):String {
		return '';//this.valuesDict[valueName][0];
	}

	private function addPort(x:Number, y:Number, property:String, type:String, direction:String):void {
		var xy:IVertex = new Vertex(x, y);
		var rel:IVertex = new RelativeVertex(view, xy);

		var point:PortPoint = new PortPoint(rel, vacuum.layout, this, property, type, direction);
		vacuum.showPort(point);

		actives[property] = point;
	}

	public function getPoint(property:String):PortPoint {
		return actives[property];
	}

	public override function toString():String {
		var msg:String = '[Node <model>]';
		msg = msg.replace(/<model>/, this.model);
		return msg;
	}
}
}