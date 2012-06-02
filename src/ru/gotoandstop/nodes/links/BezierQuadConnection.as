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

	private var _first:ITargetVertex;
	private var firstMid:RibbonVertex;
	private var _second:ITargetVertex;
	private var secondMid:RibbonVertex;

	private var spline:Spline;
	private var _view:SplineView;

	private var _canvas:DisplayObjectContainer;
	public function get canvas():DisplayObjectContainer {
		return _canvas;
	}

	public function BezierQuadConnection(canvas:DisplayObjectContainer) {
		_canvas = canvas;
		_index = SimpleLineConnection.getIndex();
		spline = new Spline(canvas);

		_view = new SplineView(spline);
		_view.alpha = 0.75;
		_canvas.addChild(_view);

		_first = new TargetVertex();
		firstMid = new RibbonVertex();
		_second = new TargetVertex();
		secondMid = new RibbonVertex();
		spline.addVertex(_first);
		spline.addVertex2(firstMid, true);
		spline.addVertex2(secondMid, true);
		spline.addVertex(_second);
	}

	public function dispose():void {
		_canvas.removeChild(_view);
		_view.dispose();
		spline.dispose();
		firstMid.dispose();
		secondMid.dispose();
		_canvas = null;
		_first = null;
		_second = null;
		firstMid = null;
		secondMid = null;
		spline = null;
		_view = null;
	}

	public function setOutsideVertices(first:IPort, second:IPort):void {
		var new_first:Boolean = first != _first.target;
		var new_second:Boolean = second != _second.target;

		_first.setTarget(first);
		_second.setTarget(second);

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

	override protected function handleTargetChange(event:Event):void {
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
