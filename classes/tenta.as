package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	public class tenta extends MovieClip {
		private const numparts:int = 20;
		private var parts:Array;
		private var cnt:Number;
		public var s0:MovieClip;
		public var s1:MovieClip;
		public var s2:MovieClip;
		public var s3:MovieClip;
		public var s4:MovieClip;
		public var s5:MovieClip;
		public var s6:MovieClip;
		public var s7:MovieClip;
		public var s8:MovieClip;
		public var s9:MovieClip;
		public var s10:MovieClip;
		public var s11:MovieClip;
		public var s12:MovieClip;
		public var s13:MovieClip;
		public var s14:MovieClip;
		public var s15:MovieClip;
		public var s16:MovieClip;
		public var s17:MovieClip;
		public var s18:MovieClip;
		public var s19:MovieClip;
		public var tmpPt:Point = new Point();
		
		function tenta(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		}
		public var _root:MovieClip;
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
	
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if( _root.stageNo > 0 ){
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
				parts = new Array(numparts);
				for ( var i:int = 0; i < numparts; i++ ) {
					parts[i] = this["s" + i];
					parts[i].gotoAndPlay((i % 20) + 1);
				}
				cnt = 0;
			}
		}

		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			var px:Number = _root.mcShip.x;
			var py:Number = _root.mcShip.y;
			tmpPt.x = px;
			tmpPt.y = py;
			var pt:Point = globalToLocal(tmpPt);
			moveTentacle( pt.x, /*this.ymouse*/pt.y, 6*_root.NEW_SIZE_RATIO, 4 );
			/*
				this.parts[19-this.count].gotoAndPlay(2);
				this.parts2[this.count].gotoAndPlay(2);
				count++;
				if( count >= 20) count = 0;
			*/
			if( cnt & 1 ){
				if( _root.mcShip.shield > 0 && hitTestPoint(px, py, true) ){
					_root.mcShip.hit();
				}
			}
			cnt++;
		}

		private function moveTentacle(tx:Number, ty:Number, speed:Number, num_loop:int):void{			
			var hx:Number = parts[0].x;
			var hy:Number = parts[0].y;
			var rx:Number = parts[numparts - 1].x;
			var ry:Number = parts[numparts-1].y;
			
			if( tx >= hx+speed ){
				hx += speed;
			}else if( tx <= hx-speed ){
				hx -= speed;
			}
			if( ty >= hy+speed ){
				hy += speed;
			}else if( ty <= hy-speed ){
				hy -= speed;
			}
			if( Math.abs(tx - hx) < speed ) hx = tx;
			if( Math.abs(ty - hy) < speed ) hy = ty;
			
			/*
			var dx = hx - rx, dy = hy - ry;
			var d = dx * dx + dy * dy;
			if( d > limit ){
				var r = Math.sqrt( limit / d );
				hx = dx * r + rx;
				hy = dy * r + ry;
			}
			*/
			
			parts[0].x = hx;
			parts[0].y = hy;
			for( var l:int = 0; l < num_loop; l++ ){
				for ( var i:int = 1; i < numparts - 1; i++ ) {
					var obj1:MovieClip = parts[i - 1];
					var obj2:MovieClip = parts[i + 1];
					parts[i].x = ( obj1.x + obj2.x ) / 2; 
					parts[i].y = ( obj1.y + obj2.y ) / 2; 
				}
			}
		}
	}
}