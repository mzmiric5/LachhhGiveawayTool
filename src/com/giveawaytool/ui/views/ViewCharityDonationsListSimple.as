package com.giveawaytool.ui.views {
	import com.giveawaytool.meta.donations.MetaCharityDonationList;
	import com.giveawaytool.meta.donations.MetaDonationList;
	import com.giveawaytool.meta.donations.MetaDonation;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhh.lachhhengine.ui.views.ViewGroupBase;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * @author LachhhSSD
	 */
	public class ViewCharityDonationsListSimple extends ViewGroupBase {
		public var metaDonations : MetaCharityDonationList ;

		public function ViewCharityDonationsListSimple(pScreen : UIBase, pVisual : DisplayObject) {
			super(pScreen, pVisual);
			for (var i : int = 0; i < 6; i++) {
				addView(createView(getDonationVisual(i)));	
			}
			cancelBtn.visible = false;
			showLoading(false);
		}
		
		private function createView(visual:MovieClip):ViewCharityDonationBtn {
			var result:ViewCharityDonationBtn = new ViewCharityDonationBtn(screen, visual);
			return result;
		}
		
		public function showLoading(b:Boolean):void {
			loadingMc.visible = b;
			donationListMc.visible = !b;
		}
		
		override public function refresh() : void {
			super.refresh();
			if(metaDonations == null) return ;
			metaDonations.sortByDate();
			for (var i : int = 0; i < views.length; i++) {
				var v:ViewCharityDonationBtn = views[i] as ViewCharityDonationBtn;
				v.metaDonation = metaDonations.getMetaDonation(i);
				v.refresh(); 
			}
		}
				
		public function get loadingMc() : MovieClip { return visual.getChildByName("loadingMc") as MovieClip;}
		public function get cancelBtn() : MovieClip { return loadingMc.getChildByName("cancelBtn") as MovieClip;}
		public function get donationListMc() : MovieClip { return visual.getChildByName("donationListMc") as MovieClip;}
		public function getDonationVisual(i:int) : MovieClip { return donationListMc.getChildByName("donation" + i) as MovieClip;}
	}
}
