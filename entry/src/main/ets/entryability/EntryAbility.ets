import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import abilityAccessCtrl,{Permissions} from '@ohos.abilityAccessCtrl'
import { checkPermission, requestPermission } from '../distributed_capability/RequestPermission'
import { DistributedDeviceManager } from '../distributed_capability/DistibutedFunctions';
import preferenceUtil from '../utils/UserPreferenceUtil'
import userPrefName from '../utils/common';
import chatItemDB from '../data/chatItemDB';

const PERMISSIONS: Array<Permissions>= [
  'ohos.permission.DISTRIBUTED_DATASYNC'
] ;

export default class EntryAbility extends UIAbility {
  public getContext(): Context {
    return this.getContext();
  }

  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    console.log("Create Entry Ability") ;
    requestPermission(this.context,PERMISSIONS).then(()=>
    {
      checkPermission(this.context,PERMISSIONS) ;
    }) ;
    DistributedDeviceManager.init() ;

    //设置屏幕常亮（开发板太容易熄了）
    let thisWindow = await window.getLastWindow(this.context);
    thisWindow.setWindowKeepScreenOn(true);
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    //加载用户首选项
    await preferenceUtil.loadPreference(this.context, userPrefName);
    //初始化聊天列表数据库
    chatItemDB.initChatItemDB(this.context);

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
}
