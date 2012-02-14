/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 1/31/12
 * Time: 11:25 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.links {
import ru.gotoandstop.IDisposable;

public interface ILineConnection extends IDisposable {
	function get index():uint;
	function setOutsideVertices(first:IPort, second:IPort):void;
}
}
