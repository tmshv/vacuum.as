/**
 * User: tmshv
 * Date: 03.02.12
 * Time: 3:50
 *
 */
package ru.gotoandstop.nodes.core {
import flash.events.EventDispatcher;

[Event(name="change", type="ru.gotoandstop.nodes.core.NodeChangeEvent")]

public class SimpleNodeObject extends EventDispatcher implements INode{
	private var _name:String;
	public function get name():String {
		return _name;
	}

	public function set name(value:String):void {
		_name = value;
		notifyAbout('name', _name);
	}

	private var _type:String;
	public function get type():String {
		return _type;
	}
	public function set type(value:String):void{
		_type = value;
		notifyAbout('type', _type);
	}

	protected var _model:Object;

    private var _system:INodeSystem;
    public function get system():INodeSystem {
        return _system;
    }
    public function set system(value:INodeSystem):void{
        _system = value;
    }

	public function SimpleNodeObject() {
		_model = new Object();
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

	protected function notifyAbout(key:String, value:*):void{
		super.dispatchEvent(new NodeChangeEvent(key, value));
	}

	public function update():void {
		super.dispatchEvent(new NodeChangeEvent('', null));
	}

	public function dispose():void {
		_model = null;
	}
}
}