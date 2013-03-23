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
    function get inputPort():IPin;
    function set inputPort(value:IPin):void;
    function get outputPort():IPin;
    function set outputPort(value:IPin):void;
}
}
