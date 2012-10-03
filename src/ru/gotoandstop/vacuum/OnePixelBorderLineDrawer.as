/**
 *
 * User: tmshv
 * Date: 9/7/12
 * Time: 4:04 PM
 */
package ru.gotoandstop.vacuum {
import flash.display.Graphics;
import flash.display.GraphicsPath;

import ru.gotoandstop.vacuum.BorderedLineDrawer;

import ru.gotoandstop.vacuum.render.IDrawer;

public class OnePixelBorderLineDrawer extends  BorderedLineDrawer{
    public function OnePixelBorderLineDrawer() {
        super(0xffffffff, 1, 0x66000000, 1);
    }
}
}
