/**
 *
 * User: tmshv
 * Date: 3/14/13
 * Time: 10:24 PM
 */
package ru.gotoandstop.nodes.links {
import flash.display.Sprite;

public class DirectLinkProvider implements ILinkProvider{
    public function provideLink(output:IPin, input:IPin):ILink {
        var link:ILink = new DirectLink();
        link.lock();
        link.outputPort = output;
        link.inputPort = input;
        link.unlock();
        return link;
    }
}
}
