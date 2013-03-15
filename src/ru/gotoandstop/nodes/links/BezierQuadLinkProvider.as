/**
 *
 * User: tmshv
 * Date: 3/15/13
 * Time: 7:02 PM
 */
package ru.gotoandstop.nodes.links {
import flash.display.Sprite;

public class BezierQuadLinkProvider implements ILinkProvider{
    private var _canvas:Sprite;

    public function BezierQuadLinkProvider(canvas:Sprite) {
        _canvas = canvas;
    }

    public function provideLink(output:IPort, input:IPort):ILink {
        var link:BezierQuadLink = new BezierQuadLink(_canvas);
        link.lock();
        link.outputPort = output;
        link.inputPort = input;
        link.unlock();
        return link;
    }
}
}
