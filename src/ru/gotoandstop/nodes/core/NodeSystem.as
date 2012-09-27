package ru.gotoandstop.nodes.core {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;

import ru.gotoandstop.nodes.MouseVertex;
import ru.gotoandstop.nodes.VacuumEvent;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.commands.DeleteNodeCommand;
import ru.gotoandstop.nodes.links.PortPoint;
import ru.gotoandstop.nodes.links.PortPointType;
import ru.gotoandstop.storage.Storage;
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

    private var _mouseDownCoord:Point = new Point();

    private var connections:Vector.<Object>;
    private var fakeConnection:uint;
    private var firstPortFake:PortPoint;

    private var nodeLibrary:Object;
    private var nodes:Vector.<Node>;

    private var _storage:Storage;
    public function get storage():Storage {
        return _storage;
    }

    private var _vacuum:VacuumLayout;
    public function get vacuum():VacuumLayout {
        return _vacuum;
    }

    private var _stage:Stage;

    private var snapVerticles:Vector.<IVertex> = new Vector.<IVertex>();

    private var selectedNodes:Vector.<ISelectable> = new Vector.<ISelectable>();

    public function NodeSystem(stage:Stage, storage:Storage = null) {
        _stage = stage;
        _storage = storage ? storage : new Storage();
        nodeLibrary = new Object();
        nodes = new Vector.<Node>();
        connections = new Vector.<Object>();
        _vacuum = new VacuumLayout(this, new Layout());
        _vacuum.cursor = new MouseVertex(stage);
        _vacuum.addEventListener(VacuumEvent.ADDED_VERTEX, handleAddedVertexToVacuum);

        _stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
        _stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        _stage.addEventListener(MouseEvent.CLICK, handleStageClick);
    }

    public function registerNode(node:Object):void {
        if (!node.type || !node.object || !node.node) {
            throw new ArgumentError('node argument must contain String type, Class object and Class node fields');
        }

        trace('reg node', node.type);
        nodeLibrary[node.type] = node;
    }

    public function createNode(type:String, data:Object = null):INode {
        if (!data) data = {};
        var prototype:Object = getDefinition(type);
        if (!prototype) throw new Error('node with type %type is not registred in system'.replace(/%type/, type));

        trace('creating node', type);

        var object_definition_name:String = prototype.object;
        var node_definition_name:String = prototype.node;
        var ObjectClass:Class = getDefinitionByName(object_definition_name) as Class;
        var NodeClass:Class = getDefinitionByName(node_definition_name) as Class;
        if (!(ObjectClass && NodeClass)) {
            throw new Error("cannot create node (needed classes not found)");
        }

        var object:INode = new ObjectClass();
        object.system = this;
        object.addEventListener(Event.CHANGE, handleObjectChange);

        var node:Node = new NodeClass(object, _vacuum);
        node.doubleClickEnabled = true;
        node.addEventListener(MouseEvent.MOUSE_DOWN, handleNodeMouseDown);
        node.addEventListener(MouseEvent.MOUSE_UP, handleNodeMouseUp);
        node.id = data.id ? data.id : getUniqueName({type:type});
        node.type = type;
        node.pos.addModifier(new SnapModifier(snapVerticles, 10));

        var extras:Object = merge(prototype.extras, data.extras);
        var has_extras:Boolean = Boolean(extras);
        if (has_extras) {
            if (extras.position) {
                var pos:Object = extras.position;
                node.setCoord(pos.x, pos.y);
            }

            if (extras.color) {
                var col:uint = uint(extras.color);
                node.setTitleColor(col);
            }
        }

        var data_params:Object = {};
        if (data.params) {
            for each(var dparam:Object in data.params) {
                data_params[dparam.key] = dparam.value;
            }
        }
        var params:Array = prototype.params;
        var key:String;
        var value:Object;
        for each(var p:Object in params) {
            key = p.key;

            var custom_value:Object = data_params[key];
            if (custom_value != undefined) {
                p.value = custom_value;
            }
            node.set(key, p);
        }

        var container:DisplayObjectContainer = _vacuum.getLayer('nodes');
        container.addChild(node);
        node.setCloseCommand(new DeleteNodeCommand(node, deleteNode));
        nodes.push(node);
        super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.ADDED_NODE, false, false, node));
        return node;
    }

    private function handleNodeMouseDown(event:MouseEvent):void {
        _mouseDownCoord.x = event.stageX;
        _mouseDownCoord.y = event.stageY;
    }

    private function handleNodeMouseUp(event:MouseEvent):void {
        if (_mouseDownCoord.equals(new Point(event.stageX, event.stageY))) {
            var node:Node = event.currentTarget as Node;
            if (node.isSelected) {
                var index:int = selectedNodes.indexOf(node);
                selectedNodes.splice(index, 1);
                node.deselect();
            } else {
                if (!event.shiftKey) {
                    clearSelection();
                }
                selectedNodes.push(node);
                node.select();
            }
        }
    }

    public function getNodeByName(name:String):INode {
        for each(var node:INode in nodes) {
            if (node.id == name) return node;
        }
        return null;
    }

    public function getNodeNames():Vector.<String> {
        var names:Vector.<String> = new Vector.<String>();
        for each(var node:INode in nodes) {
            names.push(node.id);
        }
        return names;
    }

    public function connect(firstNodeName:String, firstProp:String, secondNodeName:String, secondProp:String):void {
        var from_node:Node = getNodeByName(firstNodeName) as Node;
        var to_node:Node = getNodeByName(secondNodeName) as Node;

        var d1:PortPoint = from_node.getPort(firstProp);
        var d2:PortPoint = to_node.getPort(secondProp);
        if (d1 && d2) {
            makeLink(d1, d2);
        }
    }

    /**
     *
     * @param from pressed ActivePoint
     * @param to released ActivePoint
     *
     */
    private function makeLink(from:PortPoint, to:PortPoint):void {
        for each(var con:Object in connections) {
            if (con.to == to) {
                unlink(con, true);
            }
        }

        var connection_index:uint = _vacuum.connect(from, to, fakeConnection);
        connections.push({
            from:from,
            to:to,
            vacuumIndex:connection_index
        });

        transferData(from, to, TransportOrigin.LINK_ESTABLISHING);
    }

    /**
     * magic is here!!!
     * @param to
     * @param from
     */
    private function transferData(from:PortPoint, to:PortPoint, origin:String):void {
        var dto:TransportObject = new TransportObject();
        dto.from = from.node;
        dto.to = to.node;
        dto.system = this;
        dto.fromField = from.property;
        dto.toField = to.property;
        dto.origin = origin;

        dto.transfer();
    }

    public function getLinkedValue(link:String):Object {
        var match:Array = link.match(/([:_\d\w]+).([\d\w]+)/);
        var node_name:String = match[1];
        var prop:String = match[2];
        var node:Node = getNodeByName(node_name) as Node;
        if (node) {
            return node.get(prop);
        } else {
            return null;
        }
    }

    private function unlink(connection:Object, breakVacuumConnection:Boolean = false):void {
        var to:PortPoint = connection.to;
        to.node.kill('-' + to.property);

        var index:int = connections.indexOf(connection);
        connections.splice(index, 1);

        if (breakVacuumConnection) _vacuum.breakConnection(connection.vacuumIndex);
    }

    private function handleObjectChange(event:Event):void {
        var change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            var initiator_node:INode = change.target as INode;
            for each(var connection:Object in connections) {
                const from:PortPoint = connection.from;
                const to:PortPoint = connection.to;
                if (from.node.id == initiator_node.id && change.key == from.property) {
                    transferData(from, to, TransportOrigin.NODE_UPDATE);
                }
            }
        }
    }

    public function deleteNode(node:INode):void {
        var node_visual:Node = node as Node;
        node_visual.removeEventListener(MouseEvent.MOUSE_DOWN, handleNodeMouseDown);
        node_visual.removeEventListener(MouseEvent.MOUSE_UP, handleNodeMouseDown);
        for (var i:uint; i < connections.length; i++) {
            var connection:Object = connections[i];
            if (connection.from.node == node_visual || connection.to.node == node_visual) {
                unlink(connection, true);
                i--;
            }
        }

        var index:int = nodes.indexOf(node_visual);
        nodes.splice(index, 1);

        index = selectedNodes.indexOf(node_visual);
        selectedNodes.splice(index, 1);

        var points:Vector.<PortPoint> = node_visual.getPortList();
        for each(var point:PortPoint in points) {
            if (point) _vacuum.deletePoint(point);
        }

        node_visual.object.removeEventListener(Event.CHANGE, handleObjectChange);

        super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.REMOVED_NODE, false, false, node));
        node_visual.dispose();
        var container:DisplayObjectContainer = _vacuum.getLayer('nodes');
        if (container.contains(node_visual)) {
            container.removeChild(node_visual);
        }
    }

    /**
     * v2
     * @return
     */
    public function getStructure():Object {
        var node_names:Vector.<String> = getNodeNames();
        var nodes:Array = new Array();
        for each (var id:String in node_names) {
            var node:Node = getNodeByName(id) as Node;
            var proto:Object = getDefinition(node.type);
            var params:Array = [];
//            var key_list:Vector.<String> = node.getParams();
            var key_list:Vector.<String> = getParamsFromPrototypeForSave(proto);
            for each(var key:String in key_list) {
                var forced_key:String = "+key".replace("key", key);
//                forced_key = key;
                var value:Object = node.get(forced_key);
                params.push({key:key, value:value});
            }

            var object:Object = {
                type:node.type,
                id:node.id,
                params:params,
                extras:{
                    position:{
                        x:node.x,
                        y:node.y
                    }
                }
            };
            nodes.push(object);
        }
        var links:Array = new Array();
        for each (var conection:Object in connections) {
            links.push({from:[conection.from.node.id, conection.from.property], to:[conection.to.node.id, conection.to.property]});
        }

        var defs:Array = new Array();
        for each(var def:Object in nodeLibrary) {
            defs.push(def);
        }

        return {definitions:defs, nodes:nodes, links:links, version:'2'};
    }

    private function merge(object1:Object, object2:Object):Object {
        var result:Object = {};
        var i:String;
        for (i in object1) {
            result[i] = object1[i];
        }
        for (i in object2) {
            if (result[i] == undefined) {
                result[i] = object2[i];
            }
        }

        return result;
    }

    /**
     * v1
     * @return
     */
//    public function getStructure():Object {
//        var node_names:Vector.<String> = getNodeNames();
//        var nodes:Array = new Array();
//        for each (var name:String in node_names) {
//            var node:Node = getNodeByName(name) as Node;
//            var raw_node:Object = {
//                type:node.type
//            };
//
//            //model filling
//            var model:Object = {};
//            var params:Vector.<String> = node.getParams();
//            for each(var prop:String in params) {
//                var val:* = node.get(prop);
//                if (val != null && val != undefined) {
//                    if (val is IValue) {
//                        var ival:* = (val as IValue).getValue();
//                        model[prop] = ival;
//                    } else {
//                        model[prop] = val;
//                    }
//                }
//            }
//            model.position = {
//                x:node.x,
//                y:node.y
//            }
//            model.id = node.id;
//
//            raw_node.model = model;
//            nodes.push(raw_node);
//        }
//        var links:Array = new Array();
//        for each (var conection:Object in connections) {
//            links.push({from:[conection.from.node.id, conection.from.property], to:[conection.to.node.id, conection.to.property]});
//        }
//
//        return {nodes:nodes, links:links, version:'1'};
//    }

    public function getRegistredTypes():Vector.<String> {
        var vec:Vector.<String> = new Vector.<String>();
        for (var i:String in nodeLibrary) {
            vec.push(i);
        }
        return vec;
    }

    public function getDefinition(type:String):Object {
        var proto:Object = nodeLibrary[type];

        var bytes:ByteArray = new ByteArray();
        bytes.writeObject(proto);
        bytes.position = 0;
        return bytes.readObject();

//        var node:Object = merge(proto, {});
//        return node;
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
        fakeConnection = _vacuum.connectWithMouse(firstPortFake);
    }

    /**
     * Нажатие на белую
     * @param event
     *
     */
    private function handleInVertexMouseDown(event:MouseEvent):void {
        const vertex:PortPoint = event.currentTarget as PortPoint;

        for each(var connection:Object in connections) {
            if (connection.to == vertex) {
                unlink(connection);
                fakeConnection = _vacuum.connectWithMouse(connection.from, connection.vacuumIndex);
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
            _vacuum.connect(firstPortFake, vertex, fakeConnection);
        }
    }

    private function handleInVertexMouseOut(event:MouseEvent):void {
        if (fakeConnection) {
            _vacuum.connectWithMouse(firstPortFake, fakeConnection);
        }
    }

    private function handleMouseUp(event:MouseEvent):void {
        if (!super.contains(event.target as DisplayObject)) {
            clearSelection();
        }

        _vacuum.breakConnection(fakeConnection);
        fakeConnection = 0;
        firstPortFake = null;
    }

    private function handleMouseDown(event:MouseEvent):void {
    }

    private function handleStageClick(event:MouseEvent):void {
    }

    public function dispose():void {
        for (var i:uint; i < connections.length; i++) {
            var connection:Object = connections[i];
            unlink(connection, true);
            i--;
        }

        var node_names:Vector.<String> = getNodeNames();
        for each(var name:String in node_names) {
            var n:Node = getNodeByName(name) as Node;
            n.object.system = null;
            deleteNode(n);
        }
        nodes = null;
        connections = null;
        nodeLibrary = null;

        _stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
        _stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
        _stage.removeEventListener(MouseEvent.CLICK, this.handleStageClick);
        _vacuum.removeEventListener(VacuumEvent.ADDED_VERTEX, this.handleAddedVertexToVacuum);
        _vacuum.dispose();
        _vacuum = null;

        trace("nodesystem destroyed");
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

    private function getParamsFromPrototypeForSave(proto:Object):Vector.<String> {
        var list:Vector.<String> = new Vector.<String>();
        var params:Array = proto.params;
        for each(var p:Object in params) {
            var s:Boolean = p.save == undefined || p.save;
            if (s) {
                list.push(p.key);
            }
        }
        return list;
    }


}
}