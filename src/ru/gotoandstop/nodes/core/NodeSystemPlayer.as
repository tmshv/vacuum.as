/**
 *
 * User: tmshv
 * Date: 9/26/12
 * Time: 4:50 PM
 */
package ru.gotoandstop.nodes.core {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;

import ru.gotoandstop.nodes.core.INode;

import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.INodeSystem;
import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.nodes.core.NodeSystemEvent;
import ru.gotoandstop.nodes.core.TransportObject;
import ru.gotoandstop.nodes.core.TransportOrigin;
import ru.gotoandstop.storage.Storage;

[Event(name="addedNode", type="ru.gotoandstop.nodes.core.NodeSystemEvent")]
[Event(name="removedNode", type="ru.gotoandstop.nodes.core.NodeSystemEvent")]

/**
 * @author tmshv
 */
public class NodeSystemPlayer extends EventDispatcher implements INodeSystem {
    public static function getUniqueName(params:Object = null):String {
        var prefix:String = params ? params.type : 'node';
        var timestamp:String = new Date().getTime().toString(0x10).toLowerCase();
        return prefix + '_' + timestamp;
    }

    private var connections:Vector.<Object>;

    private var nodeLibrary:Object;
    private var nodes:Vector.<INode>;

    private var _storage:Storage;
    public function get storage():Storage {
        return _storage;
    }

    public function NodeSystemPlayer(storage:Storage = null) {
        _storage = storage ? storage : new Storage();
        nodeLibrary = new Object();
        nodes = new Vector.<INode>();
        connections = new Vector.<Object>();
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

        var object_definition_name:String = prototype.object;
        var ObjectClass:Class = getDefinitionByName(object_definition_name) as Class;
        if (!ObjectClass) {
            throw new Error("cannot create node (needed classes not found)");
        }

        var node:INode = new ObjectClass();
        node.system = this;
        node.addEventListener(Event.CHANGE, handleObjectChange);

        node.id = data.id ? data.id : getUniqueName({type:type});
        node.type = type;

        var pairs:Object = getDataPairs(prototype, data);
        for (var key:String in pairs) node.set(key, pairs[key]);
        nodes.push(node);
        super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.ADDED_NODE, false, false, node));
        return node;
    }

    private function getDataPairs(prototype:Object, data:Object):Object {
        var pairs:Object = new Object();
        var pair:Object;

        for each(pair in prototype.params) pairs[pair.key] = pair.value;
        pair = null;
        for each(pair in data.params) pairs[pair.key] = pair.value;

        return pairs;
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
        for each(var con:Object in connections) {
            if (con.to == secondNodeName && con.toProp == secondProp) {
                unlink(con);
            }
        }

        connections.push({
            from:firstNodeName,
            fromProp:firstProp,
            to:secondNodeName,
            toProp:secondProp
        });

        transferData(firstNodeName, firstProp, secondNodeName, secondProp, TransportOrigin.LINK_ESTABLISHING);
    }

    private function transferData(firstNodeName:String, firstProp:String, secondNodeName:String, secondProp:String, origin:String):void {
        var from_node:INode = getNodeByName(firstNodeName);
        var to_node:INode = getNodeByName(secondNodeName);

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
        var match:Array = link.match(/([:_\d\w]+).([\d\w]+)/);
        var node_name:String = match[1];
        var prop:String = match[2];
        var node:INode = getNodeByName(node_name);
        if (node) {
            return node.get(prop);
        } else {
            return null;
        }
    }

    private function unlink(connection:Object):void {
        var to:INode = getNodeByName(connection.to);
        to.kill('-' + connection.toProp);
        var index:int = connections.indexOf(connection);
        connections.splice(index, 1);
    }

    private function handleObjectChange(event:Event):void {
        var change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            var initiator_node:INode = change.target as INode;
            for each(var connection:Object in connections) {
                const from:String = connection.from;
                const to:String = connection.to;
                if (from == initiator_node.id && change.key == connection.fromProp) {
                    transferData(from, connection.fromProp, to, connection.toProp, TransportOrigin.NODE_UPDATE);
                }
            }
        }
    }

    public function deleteNode(node:INode):void {
    }

    /**
     * v2
     * @return
     */
    public function getStructure():Object {
        return {};
    }


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

    public function dispose():void {
        for (var i:uint; i < connections.length; i++) {
            var connection:Object = connections[i];
            unlink(connection);
            i--;
        }

        var node_names:Vector.<String> = getNodeNames();
        for each(var name:String in node_names) {
            var n:INode = getNodeByName(name);
            n.system = null;
            deleteNode(n);
        }
        nodes = null;
        connections = null;
        nodeLibrary = null;
    }
}
}