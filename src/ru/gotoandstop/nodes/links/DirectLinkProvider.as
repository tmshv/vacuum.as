/**
 *
 * User: tmshv
 * Date: 3/14/13
 * Time: 10:24 PM
 */
package ru.gotoandstop.nodes.links {
import flash.display.Sprite;

public class DirectLinkProvider implements ILinkProvider{
    private var _canvas:Sprite;

    public function DirectLinkProvider(canvas:Sprite) {
        _canvas = canvas;
    }

    public function provideLink(output:IPort, input:IPort):ILink {
        var link:ILink = new DirectLink(_canvas);
        link.lock();
        link.outputPort = output;
        link.inputPort = input;
        link.unlock();
        return link;
    }
}
}
