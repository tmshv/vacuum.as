/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/7/12
 * Time: 6:55 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes {
import by.blooddy.crypto.serialization.JSON;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.nodes.core.INodeSystem;

public class JSONEncoder {
    public var readDefinition:Boolean = true;
    public var readConnections:Boolean = true;

    private var system:INodeSystem;

    public function JSONEncoder(system:INodeSystem) {
        this.system = system;
    }

    //make json from system
    public function encode():String {
        return by.blooddy.crypto.serialization.JSON.encode(system.serialize());
    }

    //make system from json shit
    public function decode(data:Object):void {
        var system_definition:Object = data is String ? by.blooddy.crypto.serialization.JSON.decode(String(data)) : data;

        var nodes:Array = system_definition.nodes;
        var links:Array = system_definition.links;
        var defs:Array = system_definition.definitions;

        if(readDefinition) {
            for each(var d:Object in defs) {
                system.registerNodeDefinition(NodeDefinition.create(d));
            }
        }

        for each(var n:Object in nodes) {
            system.createNode(n.type, n);
        }

        if(readConnections) {
            for each(var link:Object in links) {
                var from_name:String = link.from[0];
                var from_prop:String = link.from[1];
                var to_name:String = link.to[0];
                var to_prop:String = link.to[1];

                system.connect(from_name, from_prop, to_name, to_prop);
            }
        }
    }

    public function decodeToCommands(data:Object):Vector.<ICommand> {
        return null;
    }
}
}
