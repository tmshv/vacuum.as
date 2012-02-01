/**
 * Created by JetBrains Astella.
 * User: tmshv
 * Date: 1/31/12
 * Time: 10:50 AM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.vacuum.core {

public interface IMovableVertex extends IDisposableVertex{
	function moveTo(x:Number, y:Number):void;
	function moveToVertex(vertex:IVertex):void;
	function follow(vertex:IVertex):void;
	function stopFollowing():void;
}
}
