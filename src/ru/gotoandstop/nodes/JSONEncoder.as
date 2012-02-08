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
	private var system:INodeSystem;

	public function JSONEncoder(system:INodeSystem) {
		this.system = system;
	}

	//make json from system
	public function encode():String {
		return by.blooddy.crypto.serialization.JSON.encode(system.getStructure());
	}

	//make system from json shit
	public function decode(data:Object):void {
		var str:String = data.toString();
		var object:Object = data is String ? by.blooddy.crypto.serialization.JSON.decode(str) : data;

		var nodes:Array = object.nodes;
		var links:Array = object.links;

		for each(var n:Object in nodes) {
			system.createNode(n.type, n.model);
		}

		for each(var link:Object in links) {
			var from_name:String = link.from[0];
			var from_prop:String = link.from[1];
			var to_name:String = link.to[0];
			var to_prop:String = link.to[1];

			system.connect(from_name, from_prop, to_name, to_prop);
		}
	}

	public function decodeToCommands(data:Object):Vector.<ICommand> {
		return null;
	}
}
}
