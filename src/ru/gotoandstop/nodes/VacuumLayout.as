package ru.gotoandstop.nodes {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.EventDispatcher;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.links.ILink;
import ru.gotoandstop.nodes.links.ILinkProvider;
import ru.gotoandstop.nodes.links.IPort;
import ru.gotoandstop.nodes.links.Pin;
import ru.gotoandstop.ui.Element;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.view.VertexView;

[Event(name="addedVertex", type="ru.gotoandstop.nodes.VacuumEvent")]
/**
 * @author tmshv
 */
public class VacuumLayout extends Element implements IDisposable {
	private var _vertexes:Vector.<Vertex>;

	private var _layout:Layout;
	public function get layout():Layout {
		return  this._layout;
	}

	private var _links:Vector.<ILink>;
    private var _linkProvider:ILinkProvider;
	public var cursor:IPort;

	public function VacuumLayout(layout:Layout, linkProvider:ILinkProvider) {
		super();
        _layout = layout;
        _linkProvider = linkProvider;
        _vertexes = new Vector.<Vertex>();
        _links = new Vector.<ILink>();
        element("lines");
        element("nodes");
        element("activepoints");
        element("vertex");
	}

	public function connect(first:IPort, second:IPort, id:String=null):String {
		var link:ILink;
		if (id) {
			for each(var c:ILink in _links) {
				if (c.id == id) {
					link = c;
					break;
				}
			}
		}

		if (!link) {
			link = _linkProvider.provideLink(first, second);
            if(link is DisplayObject) {
                element("lines").push(link as DisplayObject);
            }
			_links.push(link);
		}else{
            link.lock();
            link.outputPort = first;
            link.inputPort = second;
            link.unlock();
        }
		return link.id;
	}

	public function connectWithMouse(port:Pin, id:String=null):String {
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

	public function showPort(point:Pin):void {
		element("activepoints").push(point);
		super.dispatchEvent(new VacuumEvent(VacuumEvent.ADDED_VERTEX, false, false, point));
	}

	public function deletePoint(point:Pin):void {
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
