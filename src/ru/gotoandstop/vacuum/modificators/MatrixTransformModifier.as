/**
 *
 * User: tmshv
 * Date: 10/5/12
 * Time: 5:34 PM
 */
package ru.gotoandstop.vacuum.modificators {
import flash.geom.Matrix;
import flash.geom.Point;

public class MatrixTransformModifier extends BaseVertexModifier{
    public var matrix:Matrix;

    public function MatrixTransformModifier(matrix:Matrix) {
        this.matrix = matrix;
    }

    override public function modify(x:Number, y:Number):Point {
        if(active && matrix) {
            return matrix.transformPoint(new Point(x, y));
        }else{
            return super.modify(x, y);
        }
    }
}
}
