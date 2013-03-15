package ru.gotoandstop.nodes {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.EventDispatcher;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.links.ILink;
import ru.gotoandstop.nodes.links.ILinkProvider;
import ru.gotoandstop.nodes.links.IPort;
import ru.gotoandstop.nodes.links.PortPoint;
import ru.gotoandstop.ui.Element;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.view.VertexView;

[Event(name="addedVertex", type="ru.gotoandstop.nodes.VacuumEvent")]
/**
 * @author tmshv
 */
public class VacuumLayout extends Element implements IDisposable {
	private var vertices:Vector.<Vertex>;

	private var _layout:Layout;
	public function get layout():Layout {
		return  this._layout;
	}

	private var _links:Vector.<ILink>;
    private var _linkProvider:ILinkProvider;
	public var cursor:IPort;

    private var __inited:Boolean;

	public function VacuumLayout(layout:Layout) {
		super();
        this._layout = layout;
		this.vertices = new Vector.<Vertex>();
		this._links = new Vector.<ILink>();

        element("lines");
        element("nodes");
        element("activepoints");
        element("vertex");
	}

    public function init(linkProvider:ILinkProvider):void{
        if(__inited) throw new Error("instance already initialized");
        _linkProvider = linkProvider;
        __inited = true;
    }

	public function connect(first:IPort, second:IPort, id:String=null):String {
		var connection:ILink;
		if (id) {
			for each(var c:ILink in _links) {
				if (c.id == id) {
					connection = c;
					break;
				}
			}
		}

		if (!connection) {
			const layer:Sprite = element("lines");
            connection = _linkProvider.provideLink(first, second);
			_links.push(connection);
		}else{
            connection.lock();
            connection.outputPort = first;
            connection.inputPort = second;
            connection.unlock();
        }
		return connection.id;
	}

	public function connectWithMouse(port:PortPoint, id:String=null):String {
		return this.connect(port, this.cursor, id);
	}

	public function addDataType(type:String, obj:*):void {

	}

	public function getDataTypeClip(type:String):Object {
		return null;
	}

	public function breakConnection(connectionIndex:String):void {
		for each(var c:ILink in this._links) {
			if (c.id == connectionIndex) {
				var index:int = this._links.indexOf(c);
				this._links.splice(index, 1);

				c.dispose();
				break;
			}
		}
	}

    public function showVertex(v:VertexView):void {
        element("vertex").push(v);
    }

    public function hideVertex(v:VertexView):void {
        const layer:Sprite = element("vertex");
        if(v && layer.contains(v)) layer.removeChild(v);
    }

	public function showPort(point:PortPoint):void {
		element("activepoints").push(point);
		super.dispatchEvent(new VacuumEvent(VacuumEvent.ADDED_VERTEX, false, false, point));
	}

	public function deletePoint(point:PortPoint):void {
        const layer:Sprite = element("activepoints");
        if(layer.contains(point)) {
            layer.removeChild(point);
            super.dispatchEvent(new VacuumEvent(VacuumEvent.REMOVED_VERTEX, false, false, point));
        }
	}

	public function dispose():void {
		for each(var c:ILink in _links) {
			c.dispose();
		}
		_links = null;
        removeChildren();
		if(cursor) cursor.dispose();
	}
}
}
