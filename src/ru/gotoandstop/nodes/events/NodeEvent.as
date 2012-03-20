/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/20/12
 * Time: 3:13 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.events {
import flash.events.Event;

import ru.gotoandstop.nodes.events.NodeEvent;

public class NodeEvent extends Event{
    public static const MOVE:String = 'move';
    
    public function NodeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
        super(type, bubbles, cancelable);
    }

    override public function clone():Event {
        return new NodeEvent(super.type, super.bubbles, super.cancelable);
    }
}
}
