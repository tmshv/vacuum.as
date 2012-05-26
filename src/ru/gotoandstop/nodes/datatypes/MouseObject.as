/**
 *
 * User: tmshv
 * Date: 5/11/12
 * Time: 4:57 PM
 */
package ru.gotoandstop.nodes.datatypes {
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.gotoandstop.nodes.core.NodeChangeEvent;

import ru.gotoandstop.nodes.core.NodeObject;

public class MouseObject extends NodeObject {
    private static const TYPES_DICT:Object = {
        click:"click",
        mouseDown:"down",
        mouseUp:"up",
        mouseMove:"move"
    };

    private static function getTypeKey(value:String):String {
        for (var key:String in TYPES_DICT) {
            if (TYPES_DICT[key] == value) {
                return key;
            }
        }
        return null;
    }

    private static function getTypeValue(key:String):String {
        return TYPES_DICT[key];
    }

    private var _target:DisplayObject;
    private var listener:String;

    public function MouseObject() {
        super.addEventListener(Event.CHANGE, handleChange);
    }

    private function handleChange(event:Event):void {
        var change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            const key:String = change.key;
            const value:Object = change.value;
            if (key == "target") {
                var target:DisplayObject = super.system.storage.get(String(value));
                clearTarget();
                _target = target;
            }
            updateListeners();
        }
    }

    private function updateListeners():void {
        if (!_target) return;

        if (listener && _target.hasEventListener(listener)) {
            _target.removeEventListener(listener, handleMouseEvent);
        }
        var event_type:String = getTypeKey(get("event"));
        if (event_type) {
            listener = event_type;
            _target.addEventListener(listener, handleMouseEvent);
        }
    }

    private function handleMouseEvent(event:MouseEvent):void {
        super.set("action", {
            action:getTypeValue(event.type),
            localX:event.localX,
            localY:event.localY,
            stageX:event.stageX,
            stageY:event.stageY,
            altKey:event.altKey,
            ctrlKey:event.ctrlKey,
            shiftKey:event.shiftKey
        });
    }

    private function clearTarget():void {
        if (_target) {
            if (listener && _target.hasEventListener(listener)) {
                _target.removeEventListener(listener, handleMouseEvent);
            }
            _target = null;
        }
    }
}
}
