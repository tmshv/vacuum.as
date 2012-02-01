/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 1/31/12
 * Time: 11:27 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.lines {
import flash.display.DisplayObjectContainer;

import ru.gotoandstop.vacuum.Spline;
import ru.gotoandstop.vacuum.SplineView;
import ru.gotoandstop.vacuum.core.ITargetVertex;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.TargetVertex;

public class SimpleLineConnection implements ILineConnection {
	private static var count:uint = 1;

	private static function getIndex():uint {
		return count++;
	}

	protected var _canvas:DisplayObjectContainer;
	public function get canvas():DisplayObjectContainer {
		return _canvas;
	}

	private var _index:uint;
	public function get index():uint {
		return _index;
	}

	protected var _first:ITargetVertex;
	protected var _second:ITargetVertex;

	protected var _spline:Spline;
	protected var _view:SplineView;

	public function SimpleLineConnection(canvas:DisplayObjectContainer) {
		_canvas = canvas;
		_index = SimpleLineConnection.getIndex();

		_first = new TargetVertex();
		_second = new TargetVertex();

		_spline = new Spline();
		_view = new SplineView(_spline);
		_view.alpha = 0.25;
		_canvas.addChild(_view);

		fillSpline();
	}

	protected function fillSpline():void {
		_spline.addVertex(_first);
		_spline.addVertex(_second);
	}

	public function setOutsideVertices(first:IVertex, second:IVertex):void {
		_first.setTarget(first);
		_second.setTarget(second);
	}

	public function dispose():void {
		_canvas.removeChild(_view);
		_view.dispose();
		_spline.dispose();
		_canvas = null;
		_first = null;
		_second = null;
		_spline = null;
		_view = null;
	}
}
}
