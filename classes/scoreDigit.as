package 
{
	import flash.display.*;
	import flash.events.*;

	public class scoreDigit extends MovieClip {
		public var numc:MovieClip;
		public var numd:MovieClip;
		public var nume:MovieClip;
		public var numf:MovieClip;
		public var numg:MovieClip;
		public var numh:MovieClip;
		public var numi:MovieClip;
		
		public function putDigit(num:Number):void{
			if( num > 9999999 )  num = num % 10000000;
			var val:Number = num;
			var i:int = Math.floor( val / 1000000 );
			val -= i * 1000000;
			var h:int = Math.floor( val / 100000 );
			val -= h * 100000;
			var g:int = Math.floor( val / 10000 );
			val -= g * 10000;
			var f:int = Math.floor( val / 1000 );
			val -= f * 1000;
			var e:int = Math.floor( val / 100 );
			val -= e * 100;
			var d:int = Math.floor( val / 10 );
			val -= d * 10;
			var c:Number = val;
			if( num < 1000000 ) numi.gotoAndStop(11);
			else numi.gotoAndStop(i+1);
			if( num < 100000 ) numh.gotoAndStop(11);
			else numh.gotoAndStop(h+1);
			if( num < 10000 ) numg.gotoAndStop(11);
			else numg.gotoAndStop(g+1);
			if( num < 1000 ) numf.gotoAndStop(11);
			else numf.gotoAndStop(f+1);
			if( num < 100 ) nume.gotoAndStop(11);
			else nume.gotoAndStop(e+1);
			if( num < 10 ) numd.gotoAndStop(11);
			else numd.gotoAndStop(d + 1);
			
			numc.gotoAndStop(c+1);
		}
		
		//2桁
		public function putDigitNN(num:Number):Number{
			var val:Number = num;
			var i:int = Math.floor( val / 1000000 );
			val -= i * 1000000;
			var h:int = Math.floor( val / 100000 );
			val -= h * 100000;
			var g:int = Math.floor( val / 10000 );
			val -= g * 10000;
			var f:int = Math.floor( val / 1000 );
			val -= f * 1000;
			var e:int = Math.floor( val / 100 );
			val -= e * 100;
			var d:int = Math.floor( val / 10 );
			val -= d * 10;
			var c:Number = val;
			numd.gotoAndStop(d+1);
			numc.gotoAndStop(c+1);
		}
	}
}