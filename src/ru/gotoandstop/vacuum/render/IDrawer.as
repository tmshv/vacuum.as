/**
 *
 * User: tmshv
 * Date: 9/7/12
 * Time: 4:07 PM
 */
package ru.gotoandstop.vacuum.render {
import flash.display.Graphics;
import flash.display.GraphicsPath;

public interface IDrawer {
    function draw(canvas:Graphics, data:GraphicsPath):void;
}
}
