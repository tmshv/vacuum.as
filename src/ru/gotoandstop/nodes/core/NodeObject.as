/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/27/12
 * Time: 1:13 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.core {
import flash.events.Event;
import flash.events.EventDispatcher;

import ru.gotoandstop.storage.Storage;

public class NodeObject extends EventDispatcher implements INode{
    public static function isLink(key:String):Boolean{
        return key.charAt(0) == '-';
    }

    public static function forceRequestToOwnKey(key:String):Boolean{
        return key.charAt(0) == '+';
    }

    public static function param(key:String):String{
        var linked:Boolean = isLink(key);
        var forced:Boolean = forceRequestToOwnKey(key);
        if(linked && forced){
            return key.substr(2);
        }else if(linked || forced){
           return key.substr(1);
        }else{
            return key;
        }
    }

    public static function eventName(key:String):String{
        return "keyChange".replace("key", key.toLowerCase());
    }

    private var _name:String;
    public function get id():String {
        return _name;
    }

    public function set id(value:String):void {
        _name = value;
        notifyAbout('id', _name);
    }

    private var _type:String;
    public function get type():String {
        return _type;
    }
    public function set type(value:String):void{
        _type = value;
        notifyAbout('type', _type);
    }

    private var _system:INodeSystem;
    public function get system():INodeSystem {
        return _system;
    }
    public function set system(value:INodeSystem):void{
        _system = value;
    }

    private var _lastTransfer:TransportObject;
    public function get lastTransfer():TransportObject {
        return _lastTransfer;
    }

    public function set lastTransfer(value:TransportObject):void {
        _lastTransfer = value;
    }

    private var _storage:Storage;

    public function NodeObject() {
        _storage = new Storage();
    }

    /**
     *
     * @param key
     * @param value
     */
    protected function notifyAbout(key:String, value:*):void{
        const p:String = param(key);
        if(isLink(key) && value == null) {
            value = get(p);
        }

        super.dispatchEvent(new NodeChangeEvent(p, value));
        super.dispatchEvent(new Event(eventName(p)));
    }

    /**
     *
     */
    public function update():void {
    }

    public function on(key:String, listener:Function, useWeakReference:Boolean = false):void {
        super.addEventListener(eventName(key), listener, false, 0, useWeakReference);
    }

    public function off(key:String, listener:Function):void {
        super.removeEventListener(eventName(key), listener);
    }

    public function get(key:String):* {
        if(forceRequestToOwnKey(key)){
            return _storage.get(param(key));
        }else{
            if (isLink(key)) {
                return _storage.get(key);
            } else {
                var link:String = '-' + key;
                if (exist(link)) {
                    return system.getLinkedValue(get(link));
                }else{
                    return _storage.get(key);
                }
            }
        }
    }

    public function set(key:String, value:*):void {
        _storage.set(key, value);
        notifyAbout(key, value);
    }

    public function exist(key:String):Boolean {
        return _storage.exist(key);
    }

    public function kill(key:String):void {
        _storage.kill(key);
        notifyAbout(key, null);
    }

    public function getParams():Vector.<String> {
        var list:Vector.<String> = _storage.getKeyList();
        var result:Vector.<String> = new Vector.<String>();
        for each(var key:String in list) {
            if(!isLink(key)) {
                result.push(key);
            }
        }
        return result;
    }

    public function dispose():void {
        _storage.clear();
        _storage = null;
    }

    override public function toString():String {
        return '[node id]'.replace(/id/, id);
    }
}
}
