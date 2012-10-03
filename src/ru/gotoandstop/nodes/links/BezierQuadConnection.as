/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 29.01.12
 * Time: 19:17
 *
 */
package ru.gotoandstop.nodes.links {
import flash.display.DisplayObjectContainer;

import ru.gotoandstop.vacuum.Spline;
import ru.gotoandstop.vacuum.SplineView;
import ru.gotoandstop.vacuum.core.ITargetVertex;
import ru.gotoandstop.vacuum.core.TargetVertex;

public class BezierQuadConnection implements ILineConnection {
	private var _index:uint;
	public function get index():uint {
		return _index;
	}

    public var first:ITargetVertex;
    public var firstMid:RibbonVertex;
    public var second:ITargetVertex;
    public var secondMid:RibbonVertex;

    public var spline:Spline;
    public var view:SplineView;

	private var _canvas:DisplayObjectContainer;
	public function get canvas():DisplayObjectContainer {
		return _canvas;
	}

	public function BezierQuadConnection(canvas:DisplayObjectContainer) {
		_canvas = canvas;
		_index = SimpleLineConnection.getIndex();
		spline = new Spline(canvas);

		view = new SplineView(spline);
		view.alpha = 0.75;
		_canvas.addChild(view);

		first = new TargetVertex();
		firstMid = new RibbonVertex();
		second = new TargetVertex();
		secondMid = new RibbonVertex();
		spline.addVertex(first);
		spline.addVertex2(firstMid, true);
		spline.addVertex2(secondMid, true);
		spline.addVertex(second);
	}

	public function dispose():void {
		_canvas.removeChild(view);
		view.dispose();
		spline.dispose();
		firstMid.dispose();
		secondMid.dispose();
		_canvas = null;
		first = null;
		second = null;
		firstMid = null;
		secondMid = null;
		spline = null;
		view = null;
	}

	public function setOutsideVertices(first:IPort, second:IPort):void {
		var new_first:Boolean = first != this.first.target;
		var new_second:Boolean = second != this.second.target;

		this.first.setTarget(first);
		this.second.setTarget(second);

		firstMid.makeRibbon = new_first;
		secondMid.makeRibbon = new_second;

		// when you init connection two targets are renewed
		if(new_first && new_second){
			firstMid.makeRibbon = false;
			secondMid.makeRibbon = false;
		}

		if (new_first || new_second) {
			firstMid.setTarget(new MidPortPoint(first, second, 0.25));
			secondMid.setTarget(new MidPortPoint(second, first, 0.25));
		}
	}
}
}

import caurina.transitions.Tweener;

import flash.events.Event;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.TargetVertex;

internal class RibbonVertex extends TargetVertex {
	public var makeRibbon:Boolean;

	public function RibbonVertex() {
		super(null);
		makeRibbon = false;
	}

	override public function setTarget(vertex:IVertex):void {
		super.setTarget(vertex);
	}

	override protected function handleTargetChange(event:Event=null):void {
		if (makeRibbon) {
			Tweener.removeTweens(this);
			Tweener.addTween(this, {x:_target.x, y:_target.y, time:.25, onComplete:onAnimComplete});
		} else {
			super.setCoord(_target.x, _target.y);
		}
	}

	private function onAnimComplete():void{
		makeRibbon = false;
	}
}
