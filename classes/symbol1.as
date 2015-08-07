//徐々に下がっていく(Ｙ座標++)エフェクトMC
package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author vostok
	 */
	public class symbol1 extends MovieClip 
	{
		public var dx:Number;
		function symbol1(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 
		public var _parent:MovieClip;

		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}		
	
		private function _onLoad(e:Event):void {		
			_parent = parent as MovieClip;
			dx = 2*root.NEW_SIZE_RATIO;
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		private function _onEnterFrame(e:Event):void{
			_parent.y += 0.5*root.NEW_SIZE_RATIO;
			_parent.x += dx;
			dx = -dx;
		}		
	}
	
}