//表示中の敵リスト
package {
	import flash.display.MovieClip;
	import enemy;
	
	public class eManager {
		private var serial:Number;
		public var cast:Array;
		
		function eManager(){
			serial = 0;
			cast = new Array();
		}
		public function push(e:enemy){
			cast.push(e);
			serial++;
			e.serial = serial;
		}
		public function remove(e:enemy):Boolean{
			var n:int = cast.length;
			for( var i:int = 0; i < n; i++ ){
				if( cast[i] == e ){
					cast.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		public function removeAll():void{
			//delete cast;
			cast = null;
			cast = new Array();
			serial = 0;
		}
		public function cleanup():void {
			var n:int = cast.length;
			for ( var i:int = 0; i < n; i++ ) {
				try{
					var mc:flash.display.MovieClip = cast[i];
					mc.parent.removeChild(mc);
				}catch(e:Error){}
			}
			removeAll();
		}
		public function searchHit(x:Number, y:Number):enemy{
			var n:int = cast.length;
			for( var i:int = 0; i < n; i++ ){
				var p:MovieClip = cast[i];
				if( p.hitTestPoint(x, y, false) ){
					return p;
				}
			}
			return null;
		}
		public function flash(damage:Number):void {
			/*
			var target:Array = new Array();
			var n:int = cast.length, i:int;
			for( i = 0; i < n; i++ ){//サーチ
				var p:MovieClip = cast[i];
				if( p.wait > 0 ) continue;
				target.push(p);
			}
			n = target.length;
			for( i = 0; i < n; i++ ){
				var p2:MovieClip = target.pop();
				p2.hit(damage);
			}
			*/
		}
		public function pause(sw:Boolean):void {
			var n:int = cast.length;
			for( var i:int = 0; i < n; i++ ){
				var p:MovieClip = cast[i];
				p.pause(sw);
			}			
		}
	}
}