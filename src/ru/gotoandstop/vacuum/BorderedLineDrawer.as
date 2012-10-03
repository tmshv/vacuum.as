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

public class BorderedLineDrawer implements IDrawer {
    public var thickness:Number;
    public var borderThickness:Number;
    public var color:uint;
    public var borderColor:uint;

    public function BorderedLineDrawer(color:uint, thickness:Number, borderColor:uint = 0xff000000, borderThickness:Number=1) {
        this.thickness = thickness;
        this.borderThickness = borderThickness;
        this.color = color;
        this.borderColor = borderColor;
    }

    public function draw(canvas:Graphics, data:GraphicsPath):void {
        var fill_alpha:Number = ((color >> 24 & 0xff) / 0xff);
        var fill_color:uint = color & 0xffffff;

        var stroke_alpha:Number = ((borderColor >> 24 & 0xff) / 0xff);
        var stroke_color:uint = borderColor & 0xffffff;

        var t:Number = thickness + borderThickness + borderThickness;

        canvas.clear();
        canvas.lineStyle(Math.max(3, t), stroke_color, stroke_alpha);
        canvas.drawPath(data.commands, data.data, data.winding);

        canvas.lineStyle(Math.max(1, borderThickness), fill_color, fill_alpha);
        canvas.drawPath(data.commands, data.data, data.winding);
    }
}
}
