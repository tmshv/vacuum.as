/**
 *
 * User: tmshv
 * Date: 3/15/13
 * Time: 7:02 PM
 */
package ru.gotoandstop.nodes.links {
import flash.display.Sprite;

public class BezierQuadLinkProvider implements ILinkProvider{
    public function provideLink(output:IPin, input:IPin):ILink {
        var link:BezierQuadLink = new BezierQuadLink();
        link.lock();
        link.outputPort = output;
        link.inputPort = input;
        link.unlock();
        return link;
    }
}
}
