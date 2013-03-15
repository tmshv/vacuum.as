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

public class BezierQuadLink extends NodeLink{
    public static const TYPE:String = "bezierquad";

    public var first:ITargetVertex;
    public var firstMid:ITargetVertex;
    public var second:ITargetVertex;
    public var secondMid:ITargetVertex;

    public var spline:Spline;
    public var view:SplineView;

	public function BezierQuadLink() {
        super(TYPE);
		spline = new Spline(this);

		view = new SplineView(spline);
		view.alpha = 0.75;
		addChild(view);

		first = new TargetVertex();
		firstMid = new TargetVertex();
		second = new TargetVertex();
		secondMid = new TargetVertex();
		spline.addVertex(first);
		spline.addVertex2(firstMid, true);
		spline.addVertex2(secondMid, true);
		spline.addVertex(second);
	}

	override public function dispose():void {
		removeChild(view);
		view.dispose();
		spline.dispose();
		firstMid.dispose();
		secondMid.dispose();
		first = null;
		second = null;
		firstMid = null;
		secondMid = null;
		spline = null;
		view = null;
	}

    override protected function init():void {
        super.init();
        var new_first:Boolean = outputPort != first.target;
        var new_second:Boolean = inputPort != second.target;

        first.setTarget(outputPort);
        second.setTarget(inputPort);

//        firstMid.makeRibbon = new_first;
//        secondMid.makeRibbon = new_second;

//        when you init connection two targets are renewed
//        if(new_first && new_second){
//            firstMid.makeRibbon = false;
//            secondMid.makeRibbon = false;
//        }

        if (new_first || new_second) {
            firstMid.setTarget(new MidPortPoint(outputPort, inputPort, 0.25));
            secondMid.setTarget(new MidPortPoint(inputPort, outputPort, 0.25));
        }
    }
}
}

import caurina.transitions.Tweener;

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

	override protected function setCoordToYourself(x:Number, y:Number):void {
        if (makeRibbon) {
            Tweener.removeTweens(this);
            Tweener.addTween(this, {x:_target.x, y:_target.y, time:.25, onComplete:onAnimComplete});
        } else {
            super.setCoordToYourself(_target.x, _target.y);
        }
    }

    private function onAnimComplete():void{
		makeRibbon = false;
	}
}
