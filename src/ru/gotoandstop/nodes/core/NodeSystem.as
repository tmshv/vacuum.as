package ru.gotoandstop.nodes.core {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;

import mx.core.IFactory;

import ru.gotoandstop.nodes.*;
import ru.gotoandstop.nodes.commands.DeleteNodeCommand;
import ru.gotoandstop.nodes.links.PortPoint;
import ru.gotoandstop.nodes.links.PortPointType;
import ru.gotoandstop.ui.ISelectable;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.modificators.SnapModifier;
import ru.gotoandstop.values.IValue;

[Event(name="addedNode", type="ru.gotoandstop.nodes.core.NodeSystemEvent")]
[Event(name="removedNode", type="ru.gotoandstop.nodes.core.NodeSystemEvent")]

/**
 * @author tmshv
 */
public class NodeSystem extends Sprite implements INodeSystem {
    public static function getUniqueName(params:Object = null):String {
        var prefix:String = params ? params.type : 'node';
        var timestamp:String = new Date().getTime().toString(0x10).toLowerCase();
        return prefix + '_' + timestamp;
    }

    private var connections:Vector.<SingleConnection>;
    private var fakeConnection:uint;
    private var firstPortFake:PortPoint;

    private var nodeLibrary:Object;
    private var nodes:Vector.<Node>;
    private var vacuum:VacuumLayout;
    private var _stage:Stage;

    private var snapVerticles:Vector.<IVertex> = new Vector.<IVertex>();

    private var selectedNodes:Vector.<ISelectable> = new Vector.<ISelectable>();

    public function NodeSystem(stage:Stage) {
        _stage = stage;
        nodeLibrary = new Object();
        nodes = new Vector.<Node>();
        connections = new Vector.<SingleConnection>();
        vacuum = new VacuumLayout(this, new Layout());
        vacuum.cursor = new MouseVertex(stage);
        vacuum.addEventListener(VacuumEvent.ADDED_VERTEX, this.handleAddedVertexToVacuum);

        _stage.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
        _stage.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
        _stage.addEventListener(MouseEvent.CLICK, this.handleStageClick);
    }

    public function registerNode(node:Object):void {
        if (!node.type || !node.object || !node.node) {
            throw new ArgumentError('node argument must contain String type, Class object and Class node fields');
        }

        var model:Object = {};
        for (var i:String in node) {
            if (i != 'type' && i != 'object' && i != 'node') {
                model[i] = node[i];
            }
        }
        nodeLibrary[node.type] = {
            type:node.type,
            object:node.object,
            node:node.node,
            model:model
        };
    }

    public function createNode(type:String, model:Object = null):INode {
        var manifest:Object = nodeLibrary[type];
        var O:Class = manifest.object;
        if (O) {
            var obj:INode = new O();
        } else {
            trace('lol happend');
            return null;
        }
        var prototype:Object = manifest.model;
        model = model ? model : new Object();
        for (var v:String in prototype) {
            var val:* = model[v] ? model[v] : prototype[v];
            //trace('setting', v, val, 'to', node.name);
            obj.setKeyValue(v, val);
        }
        var N:Class = manifest.node;
        if (N) {
            var node:Node = new N(obj, vacuum);
            node.doubleClickEnabled = true;
            node.addEventListener(MouseEvent.MOUSE_DOWN, handleNodeMouseDown);
        } else {
            trace('lol happend again');
        }
        node.name = model.name ? model.name : getUniqueName({type:type});
        node.type = type;
        node.pos.addModifier(new SnapModifier(snapVerticles, 10));
        if (model.position) {
            node.setCoord(model.position.x, model.position.y);
        }

        var container:DisplayObjectContainer = vacuum.getLayer('nodes');
        container.addChild(node);
        node.setCloseCommand(new DeleteNodeCommand(node, deleteNode));
        nodes.push(node);
        super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.ADDED_NODE, false, false, node));
        return node;
    }

    private function handleNodeMouseDown(event:MouseEvent):void {
        var node:Node = event.currentTarget as Node;
        if (node.isSelected) {
            var index:int = selectedNodes.indexOf(node);
            selectedNodes.splice(index, 1);
            node.deselect();
        } else {
            if(!event.shiftKey) {
                clearSelection();
            }
            selectedNodes.push(node);
            node.select();
        }
    }

    public function getNodeByName(name:String):INode {
        for each(var node:INode in nodes) {
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
        var from_node:Node = getNodeByName(firstNodeName) as Node;
        var to_node:Node = getNodeByName(secondNodeName) as Node;

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
        to.node.setKeyValue(to.property, from.getValue());
    }

    private function unlink(connection:SingleConnection, breakVacuumConnection:Boolean = false):void {
        var to:PortPoint = connection.to;
        to.node.setKeyValue(to.property, null);

        var index:int = connections.indexOf(connection);
        connections.splice(index, 1);

        if (breakVacuumConnection) vacuum.breakConnection(connection.vacuumIndex);
    }

    public function deleteNode(node:INode):void {
        var vis:Node = node as Node;
        vis.removeEventListener(MouseEvent.DOUBLE_CLICK, handleNodeMouseDown);
        for (var i:uint; i < connections.length; i++) {
            var connection:SingleConnection = connections[i];
            if (connection.from.node == vis.model || connection.to.node == vis.model) {
                unlink(connection, true);
                i--;
            }
        }

        var index:int = nodes.indexOf(vis);
        nodes.splice(index, 1);

        index = selectedNodes.indexOf(vis);
        selectedNodes.splice(index, 1);

        var props:Vector.<String> = vis.getParams();
        for each(var prop:String in props) {
            var point:PortPoint = vis.getPoint(prop);
            if (point) vacuum.deletePoint(point);
        }

        var container:DisplayObjectContainer = vacuum.getLayer('nodes');
        if (container.contains(vis)) {
            container.removeChild(vis);
        }
        super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.REMOVED_NODE, false, false, node));
        vis.dispose();
    }

    public function getStructure():Object {
        var node_names:Vector.<String> = getNodeNames();
        var nodes:Array = new Array();
        for each (var name:String in node_names) {
            var node:Node = getNodeByName(name) as Node;
            var raw_node:Object = {
                type:node.type
            };

            //model filling
            var model:Object = {};
            var params:Vector.<String> = node.getParams();
            for each(var prop:String in params) {
                var val:* = node.getKeyValue(prop);
                if (val) {
                    if (val is IValue) {
                        var ival:* = (val as IValue).getValue();
                        if (ival) model[prop] = ival;
                    } else {
                        model[prop] = val;
                    }
                }
            }
            model.position = {
                x:node.x,
                y:node.y
            }
            model.name = node.name;

            raw_node.model = model;
            nodes.push(raw_node);
        }
        var links:Array = new Array();
        for each (var conection:SingleConnection in connections) {
            links.push({from:[conection.from.node.name, conection.from.property], to:[conection.to.node.name, conection.to.property]});
        }

        return {nodes:nodes, links:links, version:'1'};
    }

    public function getRegistredTypes():Vector.<String> {
        var vec:Vector.<String> = new Vector.<String>();
        for (var i:String in nodeLibrary) {
            vec.push(i);
        }
        return vec;
    }

    public function getDefinition(type:String):Object {
        var node:Object = nodeLibrary[type];
        var obj:Object = {
            type:node.type,
            object:node.object,
            node:node.node
        };
        for (var i:String in node.model) {
            obj[i] = node.model[i];
        }
        return obj;
//		var bytes:ByteArray = new ByteArray();
//		bytes.writeObject();
//		bytes.position = 0;
//		return bytes.readObject();
    }

    public function breakConnection(nodeName:String, nodeProp:String):void {
    }

    public function matchNodeName(pattern:RegExp):Vector.<INode> {
        return null;
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

        handleInVertexMouseOver(event);
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
        if (!super.contains(event.target as DisplayObject)) {
            clearSelection();
        }

        vacuum.breakConnection(fakeConnection);
        fakeConnection = 0;
        firstPortFake = null;
    }

    private function handleMouseDown(event:MouseEvent):void {
    }

    private function handleStageClick(event:MouseEvent):void {
    }

    public function dispose():void {
        for each(var n:INode in nodes) {
            n.dispose();
        }
        nodes = null;
        connections = null;
        nodeLibrary = null;

        _stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
        _stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
        _stage.removeEventListener(MouseEvent.CLICK, this.handleStageClick);
        vacuum.removeEventListener(VacuumEvent.ADDED_VERTEX, this.handleAddedVertexToVacuum);
        vacuum.dispose();
        vacuum = null;
    }

    public function addSnapVertex(vertex:IVertex):void {
        snapVerticles.push(vertex);
    }

    public function getSelectedNodes():Vector.<Node> {
        var result:Vector.<Node> = new Vector.<Node>();
        for each(var n:ISelectable in selectedNodes) {
            result.push(n as Node);
        }
        return result;
    }

    private function clearSelection():void {
        for each(var n:ISelectable in selectedNodes) {
            n.deselect();
        }
        selectedNodes.splice(0, selectedNodes.length);
    }
}
}
