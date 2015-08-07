//ボスのヒットエリア
package {
	import flash.display.*;
	import flash.events.*;
	
	public class bossHitarea extends enemy {
		public var master:MovieClip;//=実体  
		//public var initX:Number;
		//public var initY:Number;
		
		function bossHitarea() {
		}
		
		public override function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			x = initX;
			y = initY;
			_root.enemyManager.push(enemy(this));
			visible = false;
		}
		public override function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			_root.enemyManager.remove(enemy(this));
		}
		public override function _onEnterFrame(e:Event):void{
			x = master.x;
			y = master.y;
		}
		public override function hit(damage:Number):Number {
			return master.hit1(damage);
		}
		public override function die():void{
			//master.die();  hit()の処理で行くからこれはいらん
			super.die();
		}
	}
}
