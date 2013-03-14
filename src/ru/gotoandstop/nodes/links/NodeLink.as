/**
 *
 * User: tmshv
 * Date: 3/14/13
 * Time: 10:08 PM
 */
package ru.gotoandstop.nodes.links {
import flash.errors.IllegalOperationError;

import ru.gotoandstop.nodes.NodeSystemElementType;

public class NodeLink implements ILink{
    protected var _index:uint;
    public function get index():uint {
        return _index;
    }

    private var _type:String;
    public function get type():String {
        return _type;
    }

    private var _locked:Boolean;
    public function get isLocked():Boolean {
        return _locked;
    }

    private var _input:IPort;
    public function get inputPort():IPort {
        return _input;
    }
    public function set inputPort(value:IPort):void {
        __change = true;
        _input = value;
    }

    private var _output:IPort;
    public function get outputPort():IPort {
        return _output;
    }
    public function set outputPort(value:IPort):void {
        __change = true;
        _output = value;
    }

    private var __change:Boolean;

    public function NodeLink(linkType:String) {
        _type = linkType;
        init();
    }

    public function encode():Object {
        return {
            "elementType":NodeSystemElementType.LINK,
            "type":type,
            "index":index
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
