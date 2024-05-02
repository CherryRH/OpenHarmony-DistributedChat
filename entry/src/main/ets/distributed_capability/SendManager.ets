import ChatDataStore from './DistributedDataStore'
import {DistributedDeviceManager} from './DistibutedFunctions'
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
const logTag: string = '[SendManagerTestTag]';
const wantFlag : string = 'SEND_DISTRIBUTED_CHAT_MESSAGE';
export default class SendManager
{
  // 需要保存一个uiAbilityContext实例,用于使用startAbility传递Want
  static context:common.UIAbilityContext ;
  // 传入UIAbilityContext 因此需要在StartAbility中调用
  static init(context : common.UIAbilityContext):void
  {
    SendManager.context = context ;
  }
  // 传入DistributedFunctions中储存的networkId，与要发送的message，通过want拉起serviceAbility，由service处理。
  static async SendMessage(networkId: string , message:string)
  {
    if(!DistributedDeviceManager.localDeviceNetId)
    {
      console.error(logTag,"The Distributed Functions Dont Initialized Correctly , SendMessage Failed") ;
      return ;
    }
    let want: Want = {
      deviceId: networkId,
      bundleName: 'com.ohprp.distributedchat',
      abilityName: 'EntryAbility',
      parameters: {
        flag : wantFlag ,
        message: message ,
        sender : DistributedDeviceManager.localDeviceNetId
      }
    }
    if(!SendManager.context)
    {
      console.info(logTag,"The Context invalid , SendManager may not be initialized") ;
      return ;
    }
    else
    {
      try
      {
        SendManager.context.startAbility(want
          , (err: BusinessError) => {
            if (err.code) {
              // 处理业务逻辑错误
              console.error(`startAbility failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
          }
        )
      }
      catch(err)
      {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        console.error(`logTag,"Start Service Ability Failed , code:${code},message:${message}`) ;
      }
    }
  }
  }
