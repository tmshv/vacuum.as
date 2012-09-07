/**
 *
 * User: tmshv
 * Date: 9/7/12
 * Time: 4:04 PM
 */
package ru.gotoandstop.vacuum {
import flash.display.Graphics;
import flash.display.GraphicsPath;

import ru.gotoandstop.vacuum.render.IDrawer;

public class SimpleColorLineDrawer implements IDrawer {
    public var thickness:Number;
    public var color:uint;

    public function SimpleColorLineDrawer(thickness:Number=0, color:uint=0x000000) {
        this.color = color;
        this.thickness = thickness;
    }

    public function draw(canvas:Graphics, data:GraphicsPath):void {
        canvas.clear();
        canvas.lineStyle(thickness, color);
        canvas.drawPath(data.commands, data.data, data.winding);
    }
}
}
