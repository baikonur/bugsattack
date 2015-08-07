//スクロールする地面
package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author MH
	 */
	public class ScrollMap extends MovieClip 
	{
		private var count:int = 0;
		private var mcbx:MovieClip;
		
		function ScrollMap() {
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		}
		
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			count = 0;
			//mcbx = root["mcBgp" + root.stageNo];
			//var mcbx:MovieClip = root["mcBgp" + root.stageNo];
		}
		
		private function _onUnload(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);		
		}
		
		private function _onEnterFrame(e:Event):void {
			if ( root.playStatus == 1 ) return;
			if( root.doScroll ){
				count++;
				if ( count == 2 ) {
					var mcbx:MovieClip = root["mcBgp" + root.stageNo];
					if( y == 0 ){
						mcbx.gotoAndStop(1);
						mcbx.y = -300;
					}else if( y == 300 ){
						y = -300;
						mcbx.gotoAndStop(2);
						mcbx.y = 300;
					}
					y += 1;
					mcbx.y += 1;
					count = 0;
				}
			}
		}
	}	
}