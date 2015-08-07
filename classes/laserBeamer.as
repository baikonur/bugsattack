package {
	import flash.display.*;
	import flash.events.*;
	
	public class laserBeamer extends enemy {
		
		public function oneshotLaser(dx:Number, dy:Number, lLife:int):void{
			counter = 0;
			mcSubWapon = AttachMc.core.add(this, "laser", "mcLaser" + IDn, { initX:dx, initY:dy, life:lLife, master:this } );
			//mcSubWapon = AttachMc.core.add(_root.layer_base, "laser", "mcLaser" + IDn, { initX:x, initY:y, life:lLife, master:this } );
			mcSubWapon.rotation = rotation;
			atkCount++;
		}
		
		public override function attack():void{}
	}
}
