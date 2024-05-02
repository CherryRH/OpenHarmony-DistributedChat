import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import abilityAccessCtrl,{Permissions} from '@ohos.abilityAccessCtrl'
import { checkPermission, requestPermission } from '../distributed_capability/RequestPermission'
import { DistributedDeviceManager } from '../distributed_capability/DistibutedFunctions';
import { ReceivedMessageList } from '../distributed_capability/ReceivedMessages' ;
import preferenceUtil from '../utils/UserPreferenceUtil'
import userPrefName from '../utils/common';
import chatItemDB from '../data/chatItemDB';
import SendManager from '../distributed_capability/SendManager';
import deviceManager from '@ohos.distributedHardware.deviceManager';

const PERMISSIONS: Array<Permissions>= [
  'ohos.permission.DISTRIBUTED_DATASYNC'
] ;

export default class EntryAbility extends UIAbility {

  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    //设置屏幕常亮（开发板太容易熄了）
    let thisWindow = await window.getLastWindow(this.context);
    thisWindow.setWindowKeepScreenOn(true);

    //加载用户首选项
    await preferenceUtil.loadPreference(this.context, userPrefName);
    //初始化聊天列表数据库
    chatItemDB.initChatItemDB(this.context);

    console.log("Create Entry Ability") ;
    //申请分布式权限
    requestPermission(this.context,PERMISSIONS).then(()=>
    {
      checkPermission(this.context,PERMISSIONS) ;
    }) ;
    //分布式设备管理器初始化
    DistributedDeviceManager.init() ;
    SendManager.init(this.context) ;
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
  // 用于响应其他设备发来的消息。 已经过本机内部使用自己的networkID发消息调试，未经过其他设备协同调试。
  onNewWant(want:Want):void
  {
    if(want.parameters) {
      if (want.parameters.flag === 'SEND_DISTRIBUTED_CHAT_MESSAGE') {
        let sender: string = JSON.stringify(want.parameters.sender);
        let message: string = JSON.stringify(want.parameters.message);
        console.info('testTag', `SuccessFully Received Message ${message} from ${sender}`);
        ReceivedMessageList.NewMessage(message, sender);

      }
    }
    else
    {
      hilog.error(0x0000, 'testTag', 'Dont Received Parameter from the want');
    }
  }
}
