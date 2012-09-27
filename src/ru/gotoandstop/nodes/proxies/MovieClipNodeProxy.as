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
import flash.events.EventDispatcher;

import ru.gotoandstop.IDisposable;
import ru.gotoandstop.nodes.core.INode;
import ru.gotoandstop.nodes.core.NodeChangeEvent;
import ru.gotoandstop.storage.Storage;
import ru.gotoandstop.storage.Storage;
import ru.gotoandstop.storage.Storage;
import ru.gotoandstop.ui.Element;

[Event(name="displayObjectCreated", type="ru.gotoandstop.nodes.proxies.MovieClipNodeProxyEvent")]
[Event(name="displayObjectDefinitionNotFound", type="ru.gotoandstop.nodes.proxies.MovieClipNodeProxyEvent")]

public class MovieClipNodeProxy extends EventDispatcher implements IDisposable {
    private static const DISPLAY_OBJECT_PROPERTIES:Array = ['x', 'y', 'width', 'height', 'rotation', 'alpha'];
    private var _node:INode;
    public function get node():INode{
        return _node;
    }

//    private var containers:Storage;
    private var containers:Element;
    private var assets:Storage;
    private var clips:Storage;

    private var _clip:DisplayObject;
    private var _currentContainer:DisplayObjectContainer;

    private var _clipName:String;
    public function get clipName():String {
        return _clipName;
    }

    private var _removableObject:Boolean;

    private var _definitionHelper:IMovieClipDefinitionHelper;
    public function get definitionHelper():IMovieClipDefinitionHelper{
        return _definitionHelper;
    }

    public function MovieClipNodeProxy(node:INode, clipContainer:Element, assets:Storage, clips:Storage) {
        containers = clipContainer;
        this.assets = assets;
        this.clips = clips;
        _node = node;
        _node.addEventListener(Event.CHANGE, handleNodeChange);
        _clipName = node.id + ".clip";

        _definitionHelper = new BaseMovieClipDefinitionHelper();

        recreateObject();
    }

    public function setDefinitionHelper(helper:IMovieClipDefinitionHelper):void{
        _definitionHelper = helper;
        recreateObject();
    }

    public function update():void{
        recreateObject();
    }

    private function getContainer():DisplayObjectContainer {
        var element_name:String = _node.get("container");
        return containers.element(element_name);
    }

    private function handleNodeChange(event:Event):void {
        const change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            const key:String = change.key;
            const val:Object = _node.get(key);

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
        var definition_name:String = _node.get('asset');
        definition_name = definitionHelper.getDefinition(definition_name);
        var cont:DisplayObjectContainer = getContainer();
        if (assets.exist(definition_name)){
            _currentContainer = cont;
            const Asset:Class = assets.get(definition_name);
            _clip = new Asset();
            _clip.name = _clipName;
            if (_clip is Bitmap) {
                _clip = wrapObject(_clip);
            }
            refreshObject();

            _currentContainer.addChild(_clip);
            clips.set(_clipName, _clip);
            _node.set('clip', _clipName);//_node.set('clip', {value:_clipName, access:'read'});

            super.dispatchEvent(new MovieClipNodeProxyEvent(MovieClipNodeProxyEvent.DISPLAY_OBJECT_CREATED));
        }else{
            super.dispatchEvent(new MovieClipNodeProxyEvent(MovieClipNodeProxyEvent.DISPLAY_OBJECT_DEFINITION_NOT_FOUND));
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
                const value:Object = _node.get(prop);
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
            _node.kill('clip');
            if (_clip && _currentContainer.contains(_clip)) _currentContainer.removeChild(_clip);
        }
        _clip = null;
    }

    public function dispose():void {
        removeObject();
        _node.removeEventListener(Event.CHANGE, handleNodeChange);
        _node = null;
        containers = null;
        assets = null;
        clips = null;
    }

    private function stringParamToBoolean(key:String):Boolean {
        var prop:String = _node.get(key);
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