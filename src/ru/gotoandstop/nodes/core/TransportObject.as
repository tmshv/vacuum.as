/**
 *
 * User: tmshv
 * Date: 5/11/12
 * Time: 4:18 PM
 */
package ru.gotoandstop.nodes.core {
import ru.gotoandstop.storage.Storage;

public class TransportObject {
    public var system:INodeSystem;
    public var from:INode;
    public var to:INode;
    public var fromField:String;
    public var toField:String;
    public var origin:String;

    public function TransportObject() {
    }

    public function transfer():void {
        if (from.system == system && to.system == system) {
            to.lastTransfer = this;

            var link_name:String = '-property'
                    .replace('property', toField);
            var link:String = 'fromnode.property'
                    .replace('fromnode', from.id)
                    .replace('property', fromField);
            to.set(link_name, link);
        }
    }
}
}
