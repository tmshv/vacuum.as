/**
 * User: tmshv
 * Date: 03.02.12
 * Time: 4:23
 *
 */
package ru.gotoandstop.nodes.core{
import flash.events.IEventDispatcher;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;

import ru.gotoandstop.IDisposable;

import ru.gotoandstop.nodes.core.INode;

public interface INodeSystem extends IEventDispatcher, IDisposable{
	function registerNode(node:Object):void;
	function createNode(type:String, model:Object=null):INode;
	function getStructure():Object;
	function getNodeNames():Vector.<String>;
	function getNodeByName(name:String):INode;
	function matchNodeName(pattern:RegExp):Vector.<INode>;
	function getRegistredTypes():Vector.<String>;
	function getDefinition(type:String):Object;
	function connect(fromName:String, fromProp:String, toName:String, toProp:String):void;
	function breakConnection(nodeName:String, nodeProp:String):void;
}
}
