/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 1/31/12
 * Time: 10:57 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.vacuum.core {
import ru.gotoandstop.IDisposable;

public interface ITargetVertex extends IDisposableVertex{
	function get target():IVertex;
	function setTarget(vertex:IVertex):void;
}
}
