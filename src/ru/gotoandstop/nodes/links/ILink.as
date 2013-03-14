/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/23/12
 * Time: 6:53 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.links {
import ru.gotoandstop.IDisposable;
import ru.gotoandstop.ILockable;
import ru.gotoandstop.ISerializable;

public interface ILink extends ISerializable, ILockable, IDisposable{
    function get id():String;
    function get type():String;
    function get inputPort():IPort;
    function set inputPort(value:IPort):void;
    function get outputPort():IPort;
    function set outputPort(value:IPort):void;
}
}
