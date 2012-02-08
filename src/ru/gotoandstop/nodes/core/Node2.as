/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 03.02.12
 * Time: 3:50
 *
 */
package ru.gotoandstop.nodes.core {
import ru.gotoandstop.nodes.*;

import flash.events.EventDispatcher;

import ru.gotoandstop.nodes.datatypes.INode;

public class Node2 extends EventDispatcher implements INode{
	private var _name:String;
	private var _model:Object;

	public function Node2(model:Object, name:String) {
		if(!model) throw new Error('model must be not null');
		if(!name) throw new Error('name must be not null');
		_model = model;
		_name = name;
	}

	public function get name():String {
		return _name;
	}

	public function set name(value:String):void {
		_name = value;
		notifyAbout('name', _name);
	}

	public function get type():String {
		return "";
	}

	public function getKeyValue(key:String):* {
		return _model[key];
	}

	public function setKeyValue(key:String, value:*):void {
		_model[key] = value;
		notifyAbout(key, value);
	}

	public function getParams():Vector.<String> {
		var list:Vector.<String> = new Vector.<String>();
		for (var item:String in _model){
			list.push(item);
		}
		return list;
	}

	private function notifyAbout(key:String, value:*):void{
		super.dispatchEvent(new NodeEvent(key, value));
	}
}
}