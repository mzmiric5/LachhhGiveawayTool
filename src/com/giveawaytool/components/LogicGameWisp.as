package com.giveawaytool.components {
	import playerio.DatabaseObject;

	import com.giveawaytool.MainGame;
	import com.giveawaytool.io.PlayerIOLachhhRPGController;
	import com.giveawaytool.io.playerio.LogicServerGameWispCheck;
	import com.giveawaytool.io.playerio.MetaGameWispSub;
	import com.giveawaytool.io.playerio.MetaServerProgress;
	import com.giveawaytool.io.playerio.ModelExternalPremiumAPIEnum;
	import com.giveawaytool.io.playerio.ModelPatreonRewardEnum;
	import com.giveawaytool.io.twitch.TwitchConnection;
	import com.giveawaytool.meta.MetaGameProgress;
	import com.giveawaytool.ui.UI_AnnoyingPopup;
	import com.giveawaytool.ui.UI_LachhhToolsAds;
	import com.giveawaytool.ui.UI_LachhhToolsAds2;
	import com.giveawaytool.ui.UI_Loading;
	import com.giveawaytool.ui.UI_Menu;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author LachhhSSD
	 */
	public class LogicGameWisp extends ActorComponent {
		private var metaGameSub : MetaGameWispSub;
		private var isLoaded:Boolean = false;
		public var logicServerGameWisp : LogicServerGameWispCheck;

		public function LogicGameWisp() {
			super();
			PlayerIOLachhhRPGController.InitInstance(MainGame.instance, ModelExternalPremiumAPIEnum.TWITCH, VersionInfo.pioDebug);
			logicServerGameWisp = new LogicServerGameWispCheck();
		}
				

		public function connect() : void {
			PlayerIOLachhhRPGController.getInstance().mySecuredConnection.SecureConnectTwitch(TwitchConnection.instance.accessToken, new Callback(onLoginSuccess, this, null), new Callback(onLoginError, this, null));
			UI_Loading.show("Connecting to GameWisp");
		}

		private function onLoginSuccess() : void {
			PlayerIOLachhhRPGController.getInstance().mySecuredConnection.connectToGameRoom(new Callback(onConnectedToGame, this, null));
		}

		private function onConnectedToGame() : void {
			MetaServerProgress.instance.loadGameWishSub(TwitchConnection.getNameOfAccount(), new Callback(onLoadMySub, this, null), new Callback(onLoginError, this, null));
			MetaGameProgress.instance.metaGameWisp.loadIfEmpty();
		}

		private function onLoadMySub(db:DatabaseObject) : void {
			metaGameSub = MetaGameWispSub.createFromDb(db);
			UI_Loading.hide();
			isLoaded = true;
			if(LogicVIPAccess.isAdminAccess()) {
				logicServerGameWisp.fetchServerData();
			}
			
			checkToShowAds();
			
			UIBase.manager.refresh();
		}
		
		public function checkToShowAds():void {
			
			if(!shouldShowAnnoying()) return ;
			/*new UI_LachhhToolsAds2();
			return ;*/ 
			if(Math.random() < 0.33) {
				new UI_AnnoyingPopup();
			} else if(Math.random() < 0.5) { 
				new UI_LachhhToolsAds();
			} else {
				new UI_LachhhToolsAds2();
			}
		}
		
		public function shouldShowAnnoying():Boolean {
			if(!MetaGameProgress.instance.atLeastOneHasBeenTested()) return false;
			if(!isLoaded) return false;
			if(isBronzeTier()) return false;
			if(isSilverTier()) return false;
			
			return true;
		}
		
		public function isBronzeTier():Boolean {
			if(metaGameSub == null) return false;
			if(ModelPatreonRewardEnum.STREAMER_BRONZE.gameWispUserMeetsReward(metaGameSub)) return true;
			return false;
		}
		
		public function isSilverTier():Boolean {
			if(metaGameSub == null) return false;
			if(ModelPatreonRewardEnum.STREAMER_SILVER.gameWispUserMeetsReward(metaGameSub)) return true;
			return false;
		}

		private function onLoginError() : void {
			UI_Loading.hide();
		}
	}
}
