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

public class OnePixelBorderLineDrawer implements IDrawer {
    public function OnePixelBorderLineDrawer() {

    }

    public function draw(canvas:Graphics, data:GraphicsPath):void {
        canvas.clear();
        canvas.lineStyle(3, 0, 0.3);
        canvas.drawPath(data.commands, data.data, data.winding);

        canvas.lineStyle(1, 0xffffff);
        canvas.drawPath(data.commands, data.data, data.winding);
    }
}
}
