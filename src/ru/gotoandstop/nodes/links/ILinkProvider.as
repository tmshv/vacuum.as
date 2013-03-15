/**
 *
 * User: tmshv
 * Date: 3/14/13
 * Time: 10:22 PM
 */
package ru.gotoandstop.nodes.links {
public interface ILinkProvider {
    function provideLink(output:IPort, input:IPort):ILink;
}
}
