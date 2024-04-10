import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import { BusinessError } from "@ohos.base";
import common from '@ohos.app.ability.common';
import relationalStore from '@ohos.data.relationalStore';

export default class ChatDataStore
{
  static STORE_CONFIG:relationalStore.StoreConfig
  static store : relationalStore.RdbStore
  //
  static init(context: common.UIAbilityContext ,dataStoreName:string) : void
  {
    // set security level to S1 (default)
    ChatDataStore.STORE_CONFIG = {
      name : `${dataStoreName}.db` ,
      securityLevel :  relationalStore.SecurityLevel.S1
    }
    relationalStore.getRdbStore(context,ChatDataStore.STORE_CONFIG,(err : BusinessError
    ,store : relationalStore.RdbStore)=>
    {

      store.executeSql("CREATE TABLE IF NOT EXISTS CHAT CHAT_ID INTEGER PRIMARY　KEY , " +
        "SENDER_ID INTEGER , " +
        "RECEIVER_ID INTEGER")
      store.setDistributedTables(["CHAT"])
      ChatDataStore.store = store
    })
  }
  static updateData()
  {
    let predicates = new relationalStore.RdbPredicates('CHAT');
    if(ChatDataStore.store != undefined)
    {
      (ChatDataStore.store as relationalStore.RdbStore).sync(relationalStore.SyncMode.SYNC_MODE_PUSH, predicates, (err, result) => {
        // 判断数据同步是否成功
        if (err) {
          console.error(`Failed to sync data. Code:${err.code},message:${err.message}`);
          return;
        }
        console.info('Succeeded in syncing data.');
        for (let i = 0; i < result.length; i++) {
          console.info(`device:${result[i][0]},status:${result[i][1]}`);
        }
      })
    }
  }
  static subscribeDevice()
  {
    let devices: string[] | undefined = undefined;
    try {
      // 调用分布式数据订阅接口，注册数据库的观察者
      // 当分布式数据库中的数据发生更改时，将调用回调
      if(ChatDataStore.store != undefined) {
        (ChatDataStore.store as relationalStore.RdbStore).on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_REMOTE, (storeObserver)=>{
          devices = storeObserver
          if(devices != undefined){
            for (let i = 0; i < devices.length; i++) {
              console.info(`The data of device:${devices[i]} has been changed.`);
            }
          }
        });
      }
    } catch (err) {
      console.error('Failed to register observer. Code:${err.code},message:${err.message}');
    }
  }
  static unSubscribe()
  {
    try {
      if(ChatDataStore.store != undefined) {
        (ChatDataStore.store as relationalStore.RdbStore).off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_REMOTE, (storeObserver)=>{
        });
      }
    } catch (err) {
      console.error('Failed to unregister observer. Code:${err.code},message:${err.message}');
    }
  }
}