/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 1/31/12
 * Time: 11:27 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.links {
import flash.display.DisplayObjectContainer;

import ru.gotoandstop.vacuum.Spline;
import ru.gotoandstop.vacuum.SplineView;
import ru.gotoandstop.vacuum.core.ITargetVertex;
import ru.gotoandstop.vacuum.core.TargetVertex;

public class DirectLink extends NodeLink{
    public static const TYPE:String = "direct";

	protected var _first:ITargetVertex;
	protected var _second:ITargetVertex;

	protected var _spline:Spline;
	protected var _view:SplineView;

	public function DirectLink() {
        super(TYPE);

		_first = new TargetVertex();
		_second = new TargetVertex();

		_spline = new Spline(this);
		_view = new SplineView(_spline);
		_view.alpha = 0.25;
		addChild(_view);

		fillSpline();
	}

	protected function fillSpline():void {
		_spline.addVertex(_first);
		_spline.addVertex(_second);
	}

	override public function dispose():void {
		removeChild(_view);
		_view.dispose();
		_spline.dispose();
		_first = null;
		_second = null;
		_spline = null;
		_view = null;
	}

    override protected function init():void {
        super.init();
        if(_first && _second) {
            _first.setTarget(inputPort);
            _second.setTarget(outputPort);
        }
    }
}
}
