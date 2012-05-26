/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 03.02.12
 * Time: 4:31
 *
 */
package ru.gotoandstop.nodes.core {
import flash.events.EventDispatcher;

import ru.gotoandstop.storage.Storage;
import ru.gotoandstop.values.IValue;

public class NodePlayer extends EventDispatcher implements INodeSystem{
	private var nodeLibrary:Object;
	private var nodes:Vector.<INode>;

	public function NodePlayer() {
		nodeLibrary = new Object();
		nodes = new Vector.<INode>();
	}

	public function registerNode(node:Object):void {
		if(!node.type || !node.object || !node.node){
			throw new ArgumentError('node argument must contain String type, Class object and Class node fields');
		}

		var model:Object = {};
		for (var i:String in node) {
			if (i != 'type' && i != 'object' && i != 'node') {
				model[i] = node[i];
			}
		}
		nodeLibrary[node.type] = {
			type: node.type,
			object: node.object,
			node: node.node,
			model: model
		};
	}

	public function createNode(type:String, model:Object = null):INode {
		var manifest:Object = nodeLibrary[type];
		var O:Class = manifest.object;
		if (O) {
			var node:INode = new O();
		} else {
			trace('lol happend');
			return null;
		}
		var prototype:Object = manifest.model;
		model = model ? model : new Object();
		node.id = model.name ? model.name : NodeSystem.getUniqueName({type:type});
		node.type = type;
		
		for (var v:String in prototype) {
			var val:* = model[v] ? model[v] : prototype[v];
			node.set(v, val);
		}

		nodes.push(node);
		super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.ADDED_NODE, false, false, node));
		return node;
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
		var from_node:INode = getNodeByName(firstNodeName);
		var to_node:INode = getNodeByName(secondNodeName);
		to_node.set(secondProp, from_node.get(firstProp));
	}

	public function getStructure():Object {
		var node_names:Vector.<String> = getNodeNames();
		var nodes:Array = new Array();
		for each (var name:String in node_names) {
			var node:INode = getNodeByName(name) as Node;
			var raw_node:Object = {
				type:node.type
			};

			//model filling
			var model:Object = {};
			var params:Vector.<String> = node.getParams();
			for each(var prop:String in params) {
				var val:* = node.get(prop);
				if (val) {
					if (val is IValue) {
						var ival:* = (val as IValue).getValue();
						if (ival) model[prop] = ival;
					} else {
						model[prop] = val;
					}
				}
			}
			model.name = node.id;

			raw_node.model = model;
			nodes.push(raw_node);
		}
		var links:Array = new Array();
//		for each (var conection:SingleConnection in connections) {
//			links.push({from:[conection.from.node.name, conection.from.property], to:[conection.to.node.name, conection.to.property]});
//		}

		return {nodes:nodes, links:links, version:'1'};
	}

	public function matchNodeName(pattern:RegExp):Vector.<INode> {
		return null;
	}

	public function getRegistredTypes():Vector.<String> {
		return null;
	}

	public function getDefinition(type:String):Object {
		return null;
	}

	public function breakConnection(nodeName:String, nodeProp:String):void {
	}

	public function dispose():void {
		for each(var n:INode in nodes) {
			n.dispose();
		}
		nodes = null;
		nodeLibrary = null;
	}

    public function deleteNode(node:INode):void {
    }

    public function get storage():Storage {
        return null;
    }

    public function getLinkedValue(link:String):Object {
        return null;
    }
}
}
