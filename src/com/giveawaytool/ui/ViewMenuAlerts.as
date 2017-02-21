package com.giveawaytool.ui {
	import com.lachhh.lachhhengine.sfx.JukeBox;
	import com.giveawaytool.ui.views.ViewOptionSlider;
	import com.lachhh.flash.ui.ButtonSelect;
	import com.lachhh.io.Callback;
	import com.giveawaytool.meta.MetaGameProgress;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhh.lachhhengine.ui.views.ViewBase;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author LachhhSSD
	 */
	public class ViewMenuAlerts extends ViewBase {
		public var logicOnOffNotConnected:LogicOnOffNextFrame;
		public var viewOptionSlider:ViewOptionSlider;
		public function ViewMenuAlerts(pScreen : UIBase, pVisual : DisplayObject) {
			super(pScreen, pVisual);
			viewOptionSlider = new ViewOptionSlider(pScreen, soundSliderMc);
			viewOptionSlider.prct = JukeBox.MUSIC_VOLUME;
			viewOptionSlider.callbackOnUpdate = new Callback(onUpdateVolume, this, null);
			viewOptionSlider.callbackOnUpdateFinished = new Callback(onUpdateWidgetSound, this, null);
			screen.setNameOfDynamicBtn(applyAndSaveBtn, "Apply & Save");
			screen.setNameOfDynamicBtn(stopAllAnimBtn, "Stop All Anims");
			screen.registerClick(applyAndSaveBtn, onApplySave);
			screen.registerClick(stopAllAnimBtn, onStopAllAnims);
			screen.registerClick(tutorialBtn, onTutorialBtn);

			logicOnOffNotConnected = (screen.addComponent(new LogicOnOffNextFrame(widgetNotConnectedMc)) as LogicOnOffNextFrame);
			logicOnOffNotConnected.isOn = false;
			UI_Menu.instance.logicNotification.logicSendToWidget.onWidgetChanged.addCallback(new Callback(UIBase.manager.refresh, UIBase, null));
			UI_Menu.instance.logicNotification.logicSendToWidget.onSendFailed.addCallback(new Callback(shakeNoWidget, this, null));
			iconOnlyMc.gotoAndStop(1);
		}

		private function onUpdateWidgetSound() : void {
			UI_Menu.instance.logicNotification.logicSendToWidget.sendVolumeMaster();
		}

		private function onUpdateVolume() : void {
			JukeBox.MUSIC_VOLUME = viewOptionSlider.prct;
			JukeBox.SFX_VOLUME = viewOptionSlider.prct;
			refresh();
			//MetaGameProgress.instance.saveToLocal();
		}

		
		
		private function onTutorialBtn() : void {
			if(!UI_Menu.instance.logicNotification.logicSendToWidget.hasAWidgetConnected()) {
				new UI_TutorialWidget();
			} else if(!UI_Menu.instance.viewMenuUISelect.hasVIPAccessToBeInUI()){
				UI_Menu.instance.viewMenuUISelect.onChest();
			}
		}

		

		private function onApplySave() : void {
			UI_Menu.instance.logicNotification.logicSendToWidget.sendDonationConfig(MetaGameProgress.instance.metaDonationsConfig);
			MetaGameProgress.instance.metaDonationsConfig.isDirty = false;
			screen.doBtnPressAnim(applyAndSaveBtn);
			MetaGameProgress.instance.saveToLocal();
			refresh();
		}

		private function onStopAllAnims() : void {
			UI_Menu.instance.logicNotification.logicSendToWidget.sendForceStopAnim();
		}

		override public function refresh() : void {
			super.refresh();
			dirtyNoticeMc.visible = MetaGameProgress.instance.metaDonationsConfig.isDirty;
			if(UI_Menu.instance.logicNotification.logicSendToWidget.hasAWidgetConnected()) {
				connectedToWidgetTxt.text = "Connected to Widget";
				connectedToWidgetTxt.textColor = 0x00CC00;
				stopAllAnimBtn.deselect();
			} else {
				connectedToWidgetTxt.text = "Not Connected";
				connectedToWidgetTxt.textColor = 0xCC0000;
				stopAllAnimBtn.select();
			}
			
			if(!UI_Menu.instance.logicNotification.logicSendToWidget.hasAWidgetConnected()) {
				backMc.gotoAndStop(1);
				iconOnlyMc.visible = false;
			} else {
				backMc.gotoAndStop(2);
				iconOnlyMc.visible = true;
			}
			
			viewOptionSlider.prct = JukeBox.MUSIC_VOLUME;
			viewOptionSlider.refresh();
			refreshIcon();
			logicOnOffNotConnected.isOn = shouldShowNotConnectInfo();
		}
		
		private function refreshIcon():void {
			if(UI_Menu.instance.viewMenuUISelect.isNeedBronzeToBeHere()) {
				iconOnlyMc.gotoAndStop(1);
			} else {
				iconOnlyMc.gotoAndStop(2);
			}
		}

		private function shouldShowNotConnectInfo() : Boolean {
			if(!UI_Menu.instance.viewMenuUISelect.isUIneedsWidget()) return false;
			if(!UI_Menu.instance.logicNotification.logicSendToWidget.hasAWidgetConnected()) return true;
			if(!UI_Menu.instance.viewMenuUISelect.hasVIPAccessToBeInUI()) return true;
			
			return false;
		}
		
		public function shakeNoWidget():void {
			screen.doBtnPressAnim(widgetNotConnectedMc);
		}
		
		public function get connectedToWidgetTxt() : TextField { return visual.getChildByName("connectedToWidgetTxt") as TextField;}
		public function get dirtyNoticeMc() : MovieClip {return visual.getChildByName("dirtyNoticeMc") as MovieClip;}
		public function get applyAndSaveBtn() : MovieClip { return visual.getChildByName("applyAndSaveBtn") as MovieClip;}
		public function get stopAllAnimBtn() : ButtonSelect { return visual.getChildByName("stopAllAnimBtn") as ButtonSelect;}
		//public function get infoBtn() : MovieClip { return visual.getChildByName("infoBtn") as MovieClip;}
		public function get widgetNotConnectedMc() : MovieClip { return visual.getChildByName("widgetNotConnectedMc") as MovieClip;}
		public function get tutorialBtn() : MovieClip { return widgetNotConnectedMc.getChildByName("tutorialBtn") as MovieClip;}
		public function get backMc() : MovieClip { return widgetNotConnectedMc.getChildByName("backMc") as MovieClip;}
		public function get iconOnlyMc() : MovieClip { return backMc.getChildByName("iconOnlyMc") as MovieClip;}
		
		public function get soundSliderMc() : MovieClip { return visual.getChildByName("soundSliderMc") as MovieClip;}						
	}
}
