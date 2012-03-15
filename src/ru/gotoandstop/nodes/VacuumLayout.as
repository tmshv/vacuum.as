package ru.gotoandstop.nodes {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.EventDispatcher;

import ru.gotoandstop.IDirectionalVertex;
import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.links.BezierQuadConnection;
import ru.gotoandstop.nodes.links.ILineConnection;
import ru.gotoandstop.nodes.links.IPort;
import ru.gotoandstop.nodes.links.IPort;
import ru.gotoandstop.nodes.links.IPort;
import ru.gotoandstop.nodes.links.PortPoint;
import ru.gotoandstop.nodes.links.SimpleLineConnection;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.ITargetVertex;
import ru.gotoandstop.vacuum.core.Vertex;

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

	private var connections:Vector.<ILineConnection>;

	public var cursor:IPort;

	public function VacuumLayout(container:DisplayObjectContainer, layout:Layout) {
		super();
//		layout.scale.setValue(0.5);
		this._layout = layout;
		this.vertices = new Vector.<Vertex>();
		this._container = container;
		this.layers = new Object();
		this.connections = new Vector.<ILineConnection>();
		this.addLayer('lines');
		this.addLayer('nodes');
		this.addLayer('activepoints');
	}

	public function addLayer(name:String):void {
		var layer:Sprite = new Sprite();
		this.container.addChild(layer);
		this.layers[name] = layer;
	}

	public function getLayer(name:String):Sprite {
		return this.layers[name];
	}

	public function connect(first:IPort, second:IPort, index:uint = 0):uint {
		var connection:ILineConnection;
		if (index) {
			for each(var c:ILineConnection in connections) {
				if (c.index == index) {
					connection = c;
					break;
				}
			}
		}

		if (!connection) {
			const layer:Sprite = layers['lines'];
//			connection = new SimpleLineConnection(layer);
			connection = new BezierQuadConnection(layer);
			connections.push(connection);
		}
		connection.setOutsideVertices(first, second);
		return connection.index;
	}

	public function connectWithMouse(port:PortPoint, index:uint = 0):uint {
		return this.connect(port, this.cursor, index);
	}

	public function addDataType(type:String, obj:*):void {

	}

	public function getDataTypeClip(type:String):Object {
		return null;
	}

	public function breakConnection(connectionIndex:uint):void {
		for each(var c:ILineConnection in this.connections) {
			if (c.index == connectionIndex) {
				var index:int = this.connections.indexOf(c);
				this.connections.splice(index, 1);

				c.dispose();
				break;
			}
		}
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
		for each(var c:ILineConnection in connections) {
			c.dispose();
		}
		connections = null;

		for each(var layer:DisplayObject in layers) {
			container.removeChild(layer);
		}
		layers = null;

		if(cursor) cursor.dispose();
	}
}
}
