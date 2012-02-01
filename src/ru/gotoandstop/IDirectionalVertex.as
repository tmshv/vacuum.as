/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 29.01.12
 * Time: 18:58
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop {
import flash.events.IEventDispatcher;

import ru.gotoandstop.vacuum.core.ITargetVertex;

import ru.gotoandstop.vacuum.core.IVertex;

public interface IDirectionalVertex extends IVertex{
	function get direction():String;
	function set direction(value:String):void;
}
}
