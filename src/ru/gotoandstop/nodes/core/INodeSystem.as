/**
 * User: tmshv
 * Date: 03.02.12
 * Time: 4:23
 *
 */
package ru.gotoandstop.nodes.core {
import flash.events.IEventDispatcher;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.ISerializable;
import ru.gotoandstop.nodes.NodeDefinition;
import ru.gotoandstop.storage.Storage;

public interface INodeSystem extends IEventDispatcher, IDisposable, ISerializable{
    function registerNodeDefinition(nodeDefinition:NodeDefinition):void;

    function getNodeDefinition(type:String):NodeDefinition;

    function getRegistredTypes():Vector.<String>;

    function createNode(type:String, model:Object = null):INode;

    function deleteNode(node:INode):void ;

    function getNodesID():Vector.<String>;

    function getNodeByID(id:String):INode;

    function getLinkedValue(link:String):Object;

    function connect(outputNodeID:String, outputNodeField:String, intputNodeID:String, inputNodeField:String):void;

    function breakConnection(nodeID:String, nodeField:String):void;

    function get storage():Storage;
}
}
