/**
 *
 * User: tmshv
 * Date: 7/23/12
 * Time: 3:32 PM
 */
package ru.gotoandstop.nodes.proxies {
import flash.events.Event;

public class MovieClipNodeProxyEvent extends Event{
    public static const DISPLAY_OBJECT_DEFINITION_NOT_FOUND:String = "displayObjectDefinitionNotFound";
    public static const DISPLAY_OBJECT_CREATED:String = "displayObjectCreated";

    public function MovieClipNodeProxyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
        super(type, bubbles, cancelable);
    }
}
}
