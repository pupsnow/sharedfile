package com.esri.ags.clusterers.supportClasses
{
    import __AS3__.vec.*;
    import flash.display.*;

    final class SpritePool extends Object
    {
        private var m_vec:Vector.<Sprite>;
        static const instance:SpritePool = new SpritePool;

        function SpritePool()
        {
            this.m_vec = new Vector.<Sprite>;
            return;
        }// end function

        function releaseAllChildren(parent:Sprite) : void
        {
            var _loc_2:Sprite = null;
            while (parent.numChildren)
            {
                
                _loc_2 = parent.removeChildAt(0) as Sprite;
                if (_loc_2)
                {
                    this.m_vec.push(_loc_2);
                }
            }
            return;
        }// end function

        function release(sprite:Sprite) : void
        {
            this.m_vec.push(sprite);
            return;
        }// end function

        function acquire() : Sprite
        {
            if (this.m_vec.length === 0)
            {
                return new Sprite();
            }
            return this.m_vec.pop();
        }// end function

    }
}
