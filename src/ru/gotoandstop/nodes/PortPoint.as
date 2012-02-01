package ru.gotoandstop.nodes {
import ru.gotoandstop.IDirectionalVertex;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.view.RectIcon;
import ru.gotoandstop.vacuum.view.VertexIcon;
import ru.gotoandstop.vacuum.view.VertexView;

/**
 * @author tmshv
 */
public class PortPoint extends VertexView implements IDirectionalVertex {
	public var node:Node;
	public var property:String;
	public var type:String;

	private var _direction:String;
	public function get direction():String {
		return this._direction;
	}

	public function set direction(value:String):void {
		this._direction = value;
	}

	public function PortPoint(vertex:IVertex, layout:Layout, node:Node, property:String, type:String, direction:String) {
		this.property = property;
		this.type = type;
		this.direction = direction;

		var icon:VertexIcon;
		if (this.type == 'in') {
			icon = new RectIcon(0xff000000, 0xffffffff);
		} else {
			icon = new RectIcon(0xff000000, 0xff000000);
		}

		super(vertex, layout, icon);
		this.node = node;
	}

	public function get target():IVertex {
		return null;
	}

	public function setTarget(vertex:IVertex):void {
	}
}
}
