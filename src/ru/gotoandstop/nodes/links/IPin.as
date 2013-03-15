/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 2/14/12
 * Time: 4:03 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.links {
import ru.gotoandstop.IDirectionalVertex;
import ru.gotoandstop.IDisposable;
import ru.gotoandstop.ILockable;
import ru.gotoandstop.nodes.core.INode;

public interface IPin extends IDirectionalVertex, ILockable, IDisposable{
	function get type():String;
	function get dataType():String;

    /**
     * parent node of port
     */
    function get node():INode;
}
}
