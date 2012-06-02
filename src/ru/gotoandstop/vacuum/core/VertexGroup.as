/**
 *
 * User: tmshv
 * Date: 6/3/12
 * Time: 1:54 AM
 */
package ru.gotoandstop.vacuum.core {
import flash.events.Event;
import flash.events.IEventDispatcher;

import ru.gotoandstop.IDisposable;

import ru.gotoandstop.vacuum.core.IVertex;

import ru.gotoandstop.vacuum.core.Vertex;

public class VertexGroup extends Vertex implements IDisposable {
    private var _list:Vector.<IVertex> = new Vector.<IVertex>();
    private var _target:IEventDispatcher;

    public function VertexGroup(target:IEventDispatcher, onEnterFrame:Boolean = true) {
        _target = target;
        if (onEnterFrame) {
            _target.addEventListener(Event.ENTER_FRAME, handleTarget);
        } else {
            _target.addEventListener(Event.EXIT_FRAME, handleTarget);
        }
    }

    public function addVertex(vertex:IVertex):void {
        _list.push(vertex);
        vertex.onChange(handleVertexChange);
        update();
    }

    public function removeVertex(vertex:IVertex):void {
        var index:int = _list.indexOf(vertex);
        if (index >= -1) {
            _list.splice(index, 1);
            update();
        }
    }

    private function handleVertexChange(event:Event):void {
        changed = true;
    }

    private function handleTarget(event:Event):void {
        update();
    }

    override public function update():void {
        if (changed) {
            super.update();
        }
    }

    public function dispose():void {
        for each(var vertex:IVertex in _list) {
            vertex.offChange(handleVertexChange);
        }
        _list = null;
        _target.removeEventListener(Event.ENTER_FRAME, handleTarget);
        _target.removeEventListener(Event.EXIT_FRAME, handleTarget);
        _target = null;
    }
}
}
