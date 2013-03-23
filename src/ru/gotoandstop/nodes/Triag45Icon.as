/**
 * Created with IntelliJ IDEA.
 * User: Roman
 * Date: 18.03.13
 * Time: 22:09
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes {
import flash.display.Graphics;

import ru.gotoandstop.vacuum.view.VertexIcon;

public class Triag45Icon extends VertexIcon{
    public function Triag45Icon(stroke:uint, fill:uint, size:uint=8){
        super();

        var fill_alpha:Number = ((fill >> 24 & 0xff) / 0xff);
        var fill_color:uint = fill & 0xffffff;

        var stroke_alpha:Number = ((stroke >> 24 & 0xff) / 0xff);
        var stroke_color:uint = stroke & 0xffffff;

        var canvas:Graphics = graphics;
        canvas.clear();
        var s2:uint = size >> 1;
        drawInvisibleCircle(size+2);
        if(fill_alpha) canvas.beginFill(fill_color, fill_alpha);
        if(stroke_alpha) canvas.lineStyle(0, stroke_color, stroke_alpha);
        canvas.moveTo(0, -s2);
        canvas.lineTo(0, s2);
        canvas.lineTo(s2, 0);
        canvas.endFill();
    }
}
}
