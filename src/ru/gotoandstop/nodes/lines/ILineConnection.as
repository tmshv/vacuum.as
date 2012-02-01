/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 1/31/12
 * Time: 11:25 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.lines {
import ru.gotoandstop.IDisposable;
import ru.gotoandstop.vacuum.core.ITargetVertex;
import ru.gotoandstop.vacuum.core.IVertex;

public interface ILineConnection extends IDisposable {
	function get index():uint;
	function setOutsideVertices(first:IVertex, second:IVertex):void;
}
}
