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
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.view.VertexView;

[Event(name="addedVertex", type="ru.gotoandstop.nodes.VacuumEvent")]
/**
 * @author tmshv
 */
public class VacuumLayout extends EventDispatcher implements IDisposable {
	private var vertices:Vector.<Vertex>;
	private var _container:DisplayObjectContainer;

	public function get container():DisplayObjectContainer {
		return this._container;
	}

	private var layers:Object;
	private var _layout:Layout;
	public function get layout():Layout {
		return  this._layout;
	}

	private var _links:Vector.<ILink>;
    private var _linkProvider:ILinkProvider;
	public var cursor:IPort;

    private var __inited:Boolean;

	public function VacuumLayout(container:DisplayObjectContainer, layout:Layout) {
		super();
        this._container = container;
        this._layout = layout;
		this.vertices = new Vector.<Vertex>();
		this.layers = new Object();
		this._links = new Vector.<ILink>();

        this.addLayer('lines');
        this.addLayer('nodes');
        this.addLayer('activepoints');
        this.addLayer("vertex");
	}

    public function init(linkProvider:ILinkProvider):void{
        if(__inited) throw new Error("instance already initialized");
        _linkProvider = linkProvider;
        __inited = true;
    }

	public function addLayer(name:String):void {
		var layer:Sprite = new Sprite();
		this.container.addChild(layer);
		this.layers[name] = layer;
	}

	public function getLayer(name:String):Sprite {
		return this.layers[name];
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
			const layer:Sprite = layers['lines'];
            connection = _linkProvider.provideLink(first, second);
			_links.push(connection);
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
        const layer:Sprite = this.layers['vertex'];
        layer.addChild(v);
    }

    public function hideVertex(v:VertexView):void {
        const layer:Sprite = this.layers['vertex'];
        if(v && layer.contains(v)) layer.removeChild(v);
    }

	public function showPort(point:PortPoint):void {
		const layer:Sprite = this.layers['activepoints'];
		layer.addChild(point);
		super.dispatchEvent(new VacuumEvent(VacuumEvent.ADDED_VERTEX, false, false, point));
	}

	public function deletePoint(point:PortPoint):void {
		const layer:Sprite = this.layers['activepoints'];
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

		for each(var layer:DisplayObject in layers) {
			container.removeChild(layer);
		}
		layers = null;

		if(cursor) cursor.dispose();
	}
}
}
