package ru.gotoandstop.nodes.core {
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getDefinitionByName;

import ru.gotoandstop.nodes.NodeDefinition;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.commands.DeleteNodeCommand;
import ru.gotoandstop.nodes.links.Pin;
import ru.gotoandstop.storage.Storage;

[Event(name="nodeAdded", type="ru.gotoandstop.nodes.core.NodeSystemEvent")]
[Event(name="nodeRemoved", type="ru.gotoandstop.nodes.core.NodeSystemEvent")]

/**
 * @author tmshv
 */
public class NodeSystem extends EventDispatcher implements INodeSystem {
    public static var STRUCT_VERSION:String = "2";

    public static function getUniqueName(params:Object = null):String {
        var prefix:String = params ? params.type : 'node';
        var timestamp:String = new Date().getTime().toString(0x10).toLowerCase();
        return prefix + '_' + timestamp;
    }

    internal var connections:Vector.<Object>;
    private var nodeLibrary:Object;

    private var nodes:Vector.<Node>;
    private var _storage:Storage;
    public function get storage():Storage {
        return _storage;
    }

    private var _vacuum:VacuumLayout;

    public function NodeSystem(storage:Storage = null) {
        /**
         * todo:remove this method
         * temp method
         * @param v
         */
        _storage = storage ? storage : new Storage();
        nodeLibrary = new Object();
        nodes = new Vector.<Node>();
        connections = new Vector.<Object>();
    }

    public function initVacuum(v:VacuumLayout):void {
        _vacuum = v;
    }

    public function registerNodeDefinition(nodeDefinition:NodeDefinition):void {
        nodeLibrary[nodeDefinition.type] = nodeDefinition;
    }

    public function getNodeDefinition(type:String):NodeDefinition {
        var proto:NodeDefinition = nodeLibrary[type];
        return proto.clone();
    }

    public function getRegistredTypes():Vector.<String> {
        var vec:Vector.<String> = new Vector.<String>();
        for (var i:String in nodeLibrary) {
            vec.push(i);
        }
        return vec;
    }

    public function createNode(type:String, data:Object = null):INode {
        if (!data) data = {};
        var prototype:NodeDefinition = getNodeDefinition(type);
        if (!prototype) throw new Error('node with type %type is not registred in system'.replace(/%type/, type));

        var object_definition_name:String = prototype.nodeDefinition;
        var node_definition_name:String = prototype.vacuumNodeDefinition;
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
        node.id = data.id ? data.id : getUniqueName({type:type});

        node.type = type;
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
        var prototype_params:Vector.<Object> = prototype.params;
        var key:String;
        for each(var p:Object in prototype_params) {

            key = p.key;
            var custom_value:Object = data_params[key];
            if (custom_value != undefined) {
                p.value = custom_value;
            }
            node.set(key, p);
        }

        var container:DisplayObjectContainer = _vacuum.element("nodes");
        container.addChild(node);
        node.setCloseCommand(new DeleteNodeCommand(node, deleteNode));
        nodes.push(node);
        super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.NODE_ADDED, false, false, node));
        return node;
    }

    public function getNodeByID(id:String):INode {
        for each(var node:INode in nodes) {
            if (node.id == id) return node;
        }
        return null;
    }

    public function getNodesID():Vector.<String> {
        var names:Vector.<String> = new Vector.<String>();
        for each(var node:INode in nodes) {
            names.push(node.id);
        }
        return names;
    }

    public function connect(outputNodeID:String, outputNodeField:String, intputNodeID:String, inputNodeField:String):void {
        var from_node:Node = getNodeByID(outputNodeID) as Node;

        var to_node:Node = getNodeByID(intputNodeID) as Node;
        var d1:Pin = from_node.getPort(outputNodeField);
        var d2:Pin = to_node.getPort(inputNodeField);
        if (d1 && d2) {
            makeLink(d1, d2);
        }
    }

    internal function makeLink(output:Pin, intput:Pin, fakeConnection:String = null):void {
        for each(var con:Object in connections) {
            if (con.to == intput) {
                unlink(con, true);
            }
        }

        var connection_id:String = _vacuum.connect(output, intput, fakeConnection);

        connections.push({
            from:output,
            to:intput,
            vacuumLinkID:connection_id
        });
        transferData(output.node.id, output.property, intput.node.id, intput.property, TransportOrigin.LINK_ESTABLISHING);
    }

    private function transferData(firstNodeName:String, firstProp:String, secondNodeName:String, secondProp:String, origin:String):void {
        var from_node:INode = getNodeByID(firstNodeName);

        var to_node:INode = getNodeByID(secondNodeName);
        var dto:TransportObject = new TransportObject();
        dto.from = from_node;
        dto.to = to_node;
        dto.system = this;
        dto.fromField = firstProp;
        dto.toField = secondProp;

        dto.origin = origin;
        dto.transfer();
    }

    public function getLinkedValue(link:String):Object {
        var match:Array = link.match(/([_\d\w]+).([\d\w]+)/);
        var node_name:String = match[1];
        var prop:String = match[2];
        var node:Node = getNodeByID(node_name) as Node;
        if (node) {
            return node.get(prop);
        } else {
            return null;
        }
    }

    internal function unlink(connection:Object, breakVacuumConnection:Boolean = false):void {
        var to:Pin = connection.to;

        to.node.kill('-' + to.property);
        var index:int = connections.indexOf(connection);

        connections.splice(index, 1);
        if (breakVacuumConnection) _vacuum.breakConnection(connection.vacuumLinkID);
    }

    private function handleObjectChange(event:Event):void {
        var change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            var initiator_node:INode = change.target as INode;
            for each(var connection:Object in connections) {
                const from:Pin = connection.from;
                const to:Pin = connection.to;
                if (from.node.id == initiator_node.id && change.key == from.property) {
                    transferData(from.node.id, from.property, to.node.id, to.property, TransportOrigin.NODE_UPDATE);
                }
            }
        }
    }

    public function deleteNode(node:INode):void {
        var node_visual:Node = node as Node;
        for (var i:uint; i < connections.length; i++) {
            var connection:Object = connections[i];
            if (connection.from.node == node_visual || connection.to.node == node_visual) {
                unlink(connection, true);
                i--;
            }
        }

        var index:int = nodes.indexOf(node_visual);

        nodes.splice(index, 1);
        var points:Vector.<Pin> = node_visual.getPortList();
        for each(var point:Pin in points) {
            if (point) _vacuum.deletePoint(point);
        }


        node_visual.object.removeEventListener(Event.CHANGE, handleObjectChange);
        super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.NODE_REMOVED, false, false, node_visual));
        node_visual.dispose();
        var container:DisplayObjectContainer = _vacuum.element("nodes");
        if (container.contains(node_visual)) {
            /**
             * v2
             * @return
             */
            container.removeChild(node_visual);
        }
    }

    public function breakConnection(nodeID:String, nodeField:String):void {
    }

    public function matchNodeIDs(pattern:RegExp):Vector.<INode> {
        return null;
    }

    public function dispose():void {
        for (var i:uint; i < connections.length; i++) {
            var connection:Object = connections[i];
            unlink(connection, true);
            i--;
        }

        var node_names:Vector.<String> = getNodesID();
        for each(var name:String in node_names) {
            var n:Node = getNodeByID(name) as Node;
            n.object.system = null;
            deleteNode(n);
        }
        nodes = null;
        connections = null;
        nodeLibrary = null;
    }

    private static function getParamsFromPrototypeForSave(proto:Object):Vector.<String> {
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

    private static function merge(object1:Object, object2:Object):Object {
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

    public function serialize():Object {
        var node_names:Vector.<String> = getNodesID();
        var nodes:Array = new Array();
        for each (var id:String in node_names) {
            var node:Node = getNodeByID(id) as Node;
            var proto:Object = getNodeDefinition(node.type);
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

        return {definitions:defs, nodes:nodes, links:links, version:STRUCT_VERSION};
    }
}
}