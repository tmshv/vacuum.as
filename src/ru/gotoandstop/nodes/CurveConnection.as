/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 29.01.12
 * Time: 19:17
 *
 */
package ru.gotoandstop.nodes {
import flash.display.DisplayObjectContainer;

import ru.gotoandstop.IDirectionalVertex;
import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.MidPortPoint;
import ru.gotoandstop.nodes.MidPortPoint;
import ru.gotoandstop.vacuum.Spline;
import ru.gotoandstop.vacuum.SplineView;
import ru.gotoandstop.vacuum.core.ITargetVertex;
import ru.gotoandstop.vacuum.core.ITargetVertex;
import ru.gotoandstop.vacuum.core.ITargetVertex;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.TargetVertex;
import ru.gotoandstop.vacuum.curves.BezierCurveCubic;

internal class CurveConnection implements IDisposable {
//	public function get canvas():DisplayObjectContainer {
//		return _canvas;
//	}
//
//	private var _index:uint;
//	public function get index():uint {
//		return _index;
//	}
//
//	private var _first:ITargetVertex;
//	private var firstMid:ITargetVertex;
//	private var _second:ITargetVertex;
//	private var secondMid:ITargetVertex;
//
//	private var spline:Spline;
//	private var _view:SplineView;
//
//	public function CurveConnection(canvas:DisplayObjectContainer) {
//		_canvas = canvas;private var _canvas:DisplayObjectContainer;
//
//		_index = CurveConnection.getIndex();
//		spline = new Spline();
//
//		_view = new SplineView(spline);
//		_view.alpha = 0.5
//		_canvas.addChild(_view);
//
//		_first = new TargetVertex();
//		firstMid = new RibbonVertex();
//		_second = new TargetVertex();
//		secondMid = new RibbonVertex();
//		spline.addVertex(_first);
////		spline.addVertex(firstMid, true);
////		spline.addVertex(secondMid, true);
//		spline.addVertex(_second);
//	}
//
	public function dispose():void {
//		_canvas.removeChild(_view);
//		_view.dispose();
//		spline.dispose();
//		firstMid.dispose();
//		secondMid.dispose();
//		_canvas = null;
//		_first = null;
//		_second = null;
//		firstMid = null;
//		secondMid = null;
//		spline = null;
//		_view = null;
	}
//
//	public function setOutsideVertices(first:ITargetVertex, second:ITargetVertex):void {
//		_first.setTarget(first);
//		_second.setTarget(second);
////
////		if (new_first || new_second) {
////			firstMid.setTarget(new MidPortPoint(first, second));
////			secondMid.setTarget(new MidPortPoint(second, first));
////		}
//	}
}
}

import caurina.transitions.Tweener;

import flash.events.Event;

import ru.gotoandstop.IDirectionalVertex;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.MidPortPoint;

import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.TargetVertex;
import ru.gotoandstop.vacuum.core.Vertex;

internal class RibbonVertex extends TargetVertex{
	public function RibbonVertex() {
		super(null);
	}

//	private var _areOutsideTarget:Boolean;
//
//	/**
//	 * @areOutsideTarget не вызывается dispose, не работает анимация
//	 */
//	public function setNewTarget(target:IVertex, areOutsideTarget:Boolean):Boolean {
//		if (_target == target) return false;
//		dispose();
//		_areOutsideTarget = areOutsideTarget;
//		_target = target;
//		_target.addEventListener(Event.CHANGE, this.calc);
//		calc(null, true);
//		return true;
//	}

//	public function dispose():void {
//		if (_target) {
//			_target.removeEventListener(Event.CHANGE, this.calc);
//			if (!_areOutsideTarget) _target.dispose();
//		}
//	}

//	private function calc(event:Event, overrideOutside:Boolean = false):void {
//		var do_not_use_anim:Boolean = overrideOutside ? overrideOutside : _areOutsideTarget;
////		do_not_use_anim = true;
//		if (do_not_use_anim) {
//			super.setCoord(_target.x, _target.y);
//		} else {
//			Tweener.removeTweens(this);
//			Tweener.addTween(this, {x:_target.x, y:_target.y, time:3});
//		}
//	}
}
