/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/15/12
 * Time: 5:39 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.proxies {
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.storage.Storage;
import ru.gotoandstop.storage.Storage;
import ru.gotoandstop.storage.Storage;

public class MovieClipNodeProxy implements IDisposable {
    private static const DISPLAY_OBJECT_PROPERTIES:Array = ['x', 'y', 'width', 'height', 'rotation', 'alpha'];
    private var node:INode;
    private var containers:Storage;
    private var assets:Storage;
    private var clips:Storage;

    private var _clip:DisplayObject;
    private var _currentContainer:DisplayObjectContainer;

    private var _clipName:String;
    public function get clipName():String {
        return _clipName;
    }

    private var _removableObject:Boolean;

    public function MovieClipNodeProxy(node:INode, clipContainers:Storage, assets:Storage, clips:Storage) {
        containers = clipContainers;
        this.assets = assets;
        this.clips = clips;
        this.node = node;
        this.node.addEventListener(Event.CHANGE, handleNodeChange);
        _clipName = node.id + ".clip";

        recreateObject();
    }

    private function getContainer():DisplayObjectContainer {
        var container_name:String = node.get("container");
        if(containers.exist(container_name)){
            return containers.get(container_name);
        }else{
            return null;
        }
    }

    private function handleNodeChange(event:Event):void {
        const change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            const key:String = change.key;
            const val:Object = node.get(key);

            if (key == 'asset') {
                recreateObject();
            } else if (key == "container") {
                recreateObject();
            } else if (DISPLAY_OBJECT_PROPERTIES.indexOf(key) > -1) {
                updateObjectProperty(key, val);
            } else if (key == "visible") {
                updateObjectProperty(key, stringParamToBoolean("visible"));
            } else if (key == "mouseEnabled") {
                var mouse_enabled:Boolean = stringParamToBoolean("mouseEnabled");
                updateObjectProperty("mouseEnabled", mouse_enabled);
                updateObjectProperty("mouseChildren", mouse_enabled);
            }
        }
    }

    private function recreateObject():void {
        _removableObject = true;
        removeObject();
        var asset_name:String = node.get('asset');
        var cont:DisplayObjectContainer = getContainer();
        if (assets.exist(asset_name) && cont){
            _currentContainer = cont;
            const Asset:Class = assets.get(asset_name);
            _clip = new Asset();
            _clip.name = _clipName;
            if (_clip is Bitmap) {
                _clip = wrapObject(_clip);
            }
            refreshObject();

            _currentContainer.addChild(_clip);
            clips.set(_clipName, _clip);
            node.set('clip', {value:_clipName, access:'read'});
        }
    }

    private function wrapObject(obj:DisplayObject):DisplayObject {
        var wrapper:Sprite = new Sprite();
        wrapper.name = obj.name;
        wrapper.addChild(obj);
        return wrapper;
    }

    private function updateObjectProperty(prop:String, value:Object):void {
        if (_clip) {
            _clip[prop] = value;
        }
    }

    private function refreshObject():void {
        if (_clip) {
            for each(var prop:String in DISPLAY_OBJECT_PROPERTIES) {
                const value:Object = node.get(prop);
                if (value != null) {// && value != undefined) {
                    _clip[prop] = value;
                }
            }
            _clip.visible = stringParamToBoolean("visible");
        }
    }

    private function removeObject():void {
        if (_removableObject) {
            clips.kill(_clipName);
            node.kill('clip');
            if (_clip && _currentContainer.contains(_clip)) _currentContainer.removeChild(_clip);
        }
        _clip = null;
    }

    public function dispose():void {
        removeObject();
        node.removeEventListener(Event.CHANGE, handleNodeChange);
        node = null;
        containers = null;
        assets = null;
        clips = null;
    }

    private function stringParamToBoolean(key:String):Boolean {
        var prop:String = node.get(key);
        var true_string:Boolean = prop == "true";
        var false_string:Boolean = prop == "false";
        if (true_string) {
            return true;
        }

        if (false_string) {
            return false;
        }

        return true;
    }
}
}