/**
 *
 * User: tmshv
 * Date: 3/14/13
 * Time: 10:08 PM
 */
package ru.gotoandstop.nodes.links {
import flash.display.Sprite;
import flash.errors.IllegalOperationError;
import flash.utils.getTimer;

import ru.gotoandstop.nodes.NodeSystemElementType;

public class NodeLink extends Sprite implements ILink{
    private static function generateID():String {
        return "link"+getTimer().toString(16);
    }

    protected var _id:String;
    public function get id():String {
        return _id;
    }

    private var _type:String;
    public function get type():String {
        return _type;
    }

    private var _locked:Boolean;
    public function get isLocked():Boolean {
        return _locked;
    }

    private var _input:IPin;
    public function get inputPort():IPin {
        return _input;
    }
    public function set inputPort(value:IPin):void {
        __change = true;
        _input = value;
    }

    private var _output:IPin;
    public function get outputPort():IPin {
        return _output;
    }
    public function set outputPort(value:IPin):void {
        __change = true;
        _output = value;
    }

    private var __change:Boolean;

    public function NodeLink(linkType:String) {
        _type = linkType;
        _id = generateID();
//        init();
    }

    public function serialize():Object {
        return {
            "elementType":NodeSystemElementType.LINK,
            "type":type,
            "index":id
        };
    }

    public function decode():Object {
        throw new IllegalOperationError("cannot call decode method");
    }

    public function lock():void {
        _locked = true;
    }

    public function unlock():void {
        if(__change) {
            init();
        }
        __change = false;
        _locked = false;
    }

    protected function init():void{

    }

    public function dispose():void {
        _input = null;
        _output = null;
        lock();
    }
}
}
