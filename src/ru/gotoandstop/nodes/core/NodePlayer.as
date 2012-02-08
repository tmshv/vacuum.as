/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 03.02.12
 * Time: 4:31
 *
 */
package ru.gotoandstop.nodes.core {
import com.junkbyte.console.Cc;

import flash.events.EventDispatcher;
import flash.utils.ByteArray;

import ru.gotoandstop.nodes.SingleConnection;

import ru.gotoandstop.nodes.core.INodeSystem;
import ru.gotoandstop.nodes.core.NodeSystem;
import ru.gotoandstop.nodes.datatypes.INode;
import ru.gotoandstop.nodes.datatypes.INode;

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
		node.name = model.name ? model.name : NodeSystem.getUniqueName({type:type});
		node.type = type;
		
		for (var v:String in prototype) {
			var val:* = model[v] ? model[v] : prototype[v];
			node.setKeyValue(v, val);
		}

		nodes.push(node);
		super.dispatchEvent(new NodeSystemEvent(NodeSystemEvent.ADDED_NODE, false, false, node));
		return node;
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
		var from_node:INode = getNodeByName(firstNodeName);
		var to_node:INode = getNodeByName(secondNodeName);
		to_node.setKeyValue(secondProp, from_node.getKeyValue(firstProp));
	}

	public function getStructure():Object {
		return null;
	}

	public function matchNodeName(pattern:RegExp):Vector.<ru.gotoandstop.nodes.datatypes.INode> {
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
}
}
