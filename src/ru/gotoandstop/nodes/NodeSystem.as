package ru.gotoandstop.nodes {
import com.junkbyte.console.Cc;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.ByteArray;

import ru.gotoandstop.IDirectionalVertex;

import ru.gotoandstop.bytes.EchoBytes;
import ru.gotoandstop.nodes.SingleConnection;
import ru.gotoandstop.nodes.commands.DeleteNodeCommand;

import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.IVertex;

[Event(name="addedNode", type="ru.gotoandstop.nodes.NodeSystemEvent")]
[Event(name="removedNode", type="ru.gotoandstop.nodes.NodeSystemEvent")]

/**
 * @author tmshv
 */
public class NodeSystem extends Sprite {
	private static var counter:uint;

	public static function getUniqueName(params:Object = null):String {
		NodeSystem.counter++;
		var m:String = 'nsys_<d>';
		return m.replace(/<d>/, NodeSystem.counter);
	}

	private var storage:Object = {};

	private var connections:Vector.<SingleConnection>;
	//	private var connectionsCurves:Vector.<Object>;
	private var fakeConnection:uint;
	private var firstPortFake:PortPoint;

	private var nodeLibrary:Object;
	private var nodes:Vector.<Node>;
	private var vacuum:VacuumLayout;

	public function NodeSystem(stage:Stage) {
		nodeLibrary = new Object();
		nodes = new Vector.<Node>();
		connections = new Vector.<SingleConnection>();
		vacuum = new VacuumLayout(this, new Layout());
		vacuum.cursor = new MouseVertex(stage);
		vacuum.addEventListener(VacuumEvent.ADDED_VERTEX, this.handleAddedVertexToVacuum);

		stage.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
	}

	public function registerNode(builder:INodeBuilder, params:Object):void {
		var node:NodeVO = new NodeVO();
		node.type = builder.type;
		//node.clip = clip;
		node.clipScale = params.clipScale ? params.clipScale : new Point(1, 1);
		node.model = params.model;
		var exclude:Array = params.exclude;
		for each(var e:Object in exclude) {
			node.exclude.push(e);
		}

		var builder:INodeBuilder = builder;
		builder.init(node, vacuum.getLayer('nodes'), vacuum);

		this.nodeLibrary[builder.type] = builder;
	}

	public function addNode(type:String):Node {
		var builder:INodeBuilder = this.nodeLibrary[type];
		var node:Node = builder.createNode(NodeSystem.getUniqueName());
		completeNodeCreation(node);
		return node;
	}

	public function createNode(model:INode):Node {
		var builder:INodeBuilder = nodeLibrary[model.type];
		var node:Node = builder.createNode(model.name, model);
		completeNodeCreation(node);
		return node;
	}

	private function completeNodeCreation(node:Node):void {
		node.view.setCloseCommand(new DeleteNodeCommand(node, deleteNode));
		nodes.push(node);
		super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.ADDED_NODE, false, false, node));
	}

	public function getNodeByName(name:String):Node {
		for each(var node:Node in nodes) {
			if (node.name == name) return node;
		}
		return null;
	}

	public function getNodeNames():Vector.<String> {
		var names:Vector.<String> = new Vector.<String>();
		for each(var node:INode in nodes) {
			names.push(node.name);
		}
		return names;
	}

	public function connect(firstNodeName:String, firstProp:String, secondNodeName:String, secondProp:String):void {
		var from_node:Node = getNodeByName(firstNodeName);
		var to_node:Node = getNodeByName(secondNodeName);

		var d1:PortPoint = from_node.getPoint(firstProp);
		var d2:PortPoint = to_node.getPoint(secondProp);
		makeLink(d1, d2);
	}

	/**
	 *
	 * @param from pressed ActivePoint
	 * @param to released ActivePoint
	 *
	 */
	private function makeLink(from:PortPoint, to:PortPoint):void {
		for each(var con:SingleConnection in connections) {
			if (con.to == to) {
				unlink(con, true);
			}
		}

		var connection_index:uint = vacuum.connect(from, to, fakeConnection);
		connections.push(new SingleConnection(from, to, connection_index));

		//magic is here!!!
		to.node.setValue(to.property, from.node.model.getValue(from.property));
	}

	private function unlink(connection:SingleConnection, breakVacuumConnection:Boolean = false):void {
		trace('unlinking', connection.from.node.name, connection.from.property, connection.to.node.name, connection.to.property)

		var to:PortPoint = connection.to;
		to.node.setValue(to.property, null);

		var index:int = connections.indexOf(connection);
		connections.splice(index, 1);

		if (breakVacuumConnection) vacuum.breakConnection(connection.vacuumIndex);
	}

	private function deleteNode(node:Node):void {
		for (var i:uint; i < connections.length; i++) {
			trace(connections.length)
			var connection:SingleConnection = connections[i];
			if (connection.from.node == node || connection.to.node == node) {
				unlink(connection, true);
				i--;
			}
		}

		var index:int = nodes.indexOf(node);
		nodes.splice(index, 1);

		var props:Vector.<String> = node.getParams();
		for each(var prop:String in props) {
			var point:PortPoint = node.getPoint(prop);
			vacuum.deletePoint(point);
		}

		//		vacuum.

		node.dispose();
	}

	public function loadBytes(bytes:ByteArray):void {
		bytes.position = 0;
		var obj:Object = bytes.readObject();
		storage['sysbytes'] = obj;
		Cc.log(obj);
		var nodes:Array = obj.nodes;
		var coords:Array = obj.coords;
		var links:Array = obj.links;

		var created_nodes:Vector.<Node> = new Vector.<Node>();
		for (var i:uint; i < nodes.length; i++) {
			var n:INode = nodes[i];
			var c:Object = coords[i];
			var node:Node = createNode(n);
			created_nodes.push(node);

			node.view.setCoord(c.x, c.y);
		}

		for each (var link:Object in links) {
			var from_name:String = link.from[0];
			var from_prop:String = link.from[1];
			var to_name:String = link.to[0];
			var to_prop:String = link.to[1];

			connect(from_name, from_prop, to_name, to_prop);
		}
	}

	public function toByteArray():ByteArray {
		var node_names:Vector.<String> = getNodeNames();
		var nodes:Array = new Array();
		var coords:Array = new Array();
		for each (var name:String in node_names) {
			var node:Node = getNodeByName(name);
			nodes.push(node.model);
			coords.push({x:node.view.x, y:node.view.y});
		}
		var links:Array = new Array();
		for each (var conection:SingleConnection in connections) {
			links.push({from:[conection.from.node.name, conection.from.property], to:[conection.to.node.name, conection.to.property]});
		}

		var obj:Object = {nodes:nodes, links:links, coords:coords, version:'1'}; // TODO: need to store cusom node view only info (i.e, node model - number, node view - range of numbers
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject(obj);

		return bytes;
	}

	private function handleAddedVertexToVacuum(event:VacuumEvent):void {
		const vertex:PortPoint = event.vertex as PortPoint;
		if (vertex.type == PortPointType.IN) {
			vertex.addEventListener(MouseEvent.MOUSE_DOWN, this.handleInVertexMouseDown);
			vertex.addEventListener(MouseEvent.MOUSE_UP, this.handleInVertexMouseUp);
			vertex.addEventListener(MouseEvent.MOUSE_OVER, this.handleInVertexMouseOver);
			vertex.addEventListener(MouseEvent.MOUSE_OUT, this.handleInVertexMouseOut);
		} else if (vertex.type == PortPointType.OUT) {
			vertex.addEventListener(MouseEvent.MOUSE_DOWN, this.handleOutVertexMouseDown);
		}
	}

	private function printNodeBytes(nodeName:String):void {
		var node:Node = getNodeByName(nodeName);
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject(node.model);
		var str:String = EchoBytes.echo(bytes, 0, 0, 0, false);
		Cc.log(str);

		bytes.position = 0;
		var obj:Object = bytes.readObject();
		this.storage[nodeName] = obj;
		Cc.log(obj);
		for (var i:String in obj) {
			Cc.log(i, obj[i]);
		}
	}

	/**
	 * Нажатие на черную
	 * @param event
	 *
	 */
	private function handleOutVertexMouseDown(event:MouseEvent):void {
		var vertex:PortPoint = event.currentTarget as PortPoint;
		firstPortFake = vertex;
		fakeConnection = vacuum.connectWithMouse(firstPortFake);
	}

	/**
	 * Нажатие на белую
	 * @param event
	 *
	 */
	private function handleInVertexMouseDown(event:MouseEvent):void {
		const vertex:PortPoint = event.currentTarget as PortPoint;

		for each(var connection:SingleConnection in connections) {
			if (connection.to == vertex) {
				unlink(connection);
				fakeConnection = vacuum.connectWithMouse(connection.from, connection.vacuumIndex);
				firstPortFake = connection.from;
			}
		}

	}

	/**
	 * Отпуск над белой
	 * @param event
	 *
	 */
	private function handleInVertexMouseUp(event:MouseEvent):void {
		const vertex:PortPoint = event.currentTarget as PortPoint;
		makeLink(firstPortFake, vertex);
		fakeConnection = 0;
		firstPortFake = null;
	}

	private function handleInVertexMouseOver(event:MouseEvent):void {
		const vertex:PortPoint = event.currentTarget as PortPoint;
		if (fakeConnection) {
			vacuum.connect(firstPortFake, vertex, fakeConnection);
		}
	}

	private function handleInVertexMouseOut(event:MouseEvent):void {
		if (fakeConnection) {
			vacuum.connectWithMouse(firstPortFake, fakeConnection);
		}
	}

	private function handleMouseUp(event:MouseEvent):void {
		vacuum.breakConnection(fakeConnection);
		fakeConnection = 0;
		firstPortFake = null;
	}
}
}
