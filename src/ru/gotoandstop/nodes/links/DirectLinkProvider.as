/**
 *
 * User: tmshv
 * Date: 3/14/13
 * Time: 10:24 PM
 */
package ru.gotoandstop.nodes.links {
import flash.display.Sprite;

public class DirectLinkProvider implements ILinkProvider{
    private var _layer:Sprite;

    public function DirectLinkProvider(layer:Sprite) {
        _layer = layer;
    }

    public function provideLink(output:IPort, input:IPort):ILink {
        var link:ILink = new DirectLink(_layer);
        link.lock();
        link.inputPort = input;
        link.outputPort = output;
        link.unlock();
        return link;
    }
}
}
