import deviceManager from '@ohos.distributedHardware.deviceManager';
import UIAbility from '@ohos.app.ability.UIAbility';

const logTag: string = '[DistributedDeviceManagerTestTag]';

export class DistributedDeviceManager {
  static pDeviceManager: deviceManager.DeviceManager;
  static subscribeID: number;
  static publishID: number;
  static distributedDeviceList: Array<deviceManager.DeviceInfo> = [];

  static init() {
    // call create Device Manager , pass a callback function . 2 para : error : error code , pass 1 when error in create
    // call create Device Manager , pass a callback function . 2 para : error : error code , pass 1 when error in create
    // data  : type is deviceManager.DeviceManager
    deviceManager.createDeviceManager("com.ohprp.distributedchat", (error, data) => {

      if (error) {
        console.error(logTag, `create device manager failed,error:${error.message}`);
        return;
      }
      DistributedDeviceManager.pDeviceManager = data;
      console.info(logTag, 'create device manager successfully');
      try {
        DistributedDeviceManager.publishID = Math.floor(Math.random() * 10000 + 1000);
        // 发布周边设备识别;若上一次发布还没有结束，则会返回Publish invalid
        data.publishDeviceDiscovery({
          publishId: DistributedDeviceManager.publishID,
          mode: deviceManager.DiscoverMode.DISCOVER_MODE_ACTIVE,
          freq: deviceManager.ExchangeFreq.HIGH,
          ranging: false
        })
        console.info(logTag, 'publishDeviceDiscovery successfully')
      } catch (error) {
        console.error(logTag, `publishDeviceDiscovery failed,error:${error}`)
      }
      try {
        // 注册设备状态改变回调。
        data.on('deviceStateChange', (data) => {
          console.info(logTag, "deviceStateChange on:" + JSON.stringify(data))
          if (data.action == deviceManager.DeviceStateChangeAction.READY) {
            AppStorage.Set('statusColor', '#ff4fc100')
          } else if (data.action == deviceManager.DeviceStateChangeAction.OFFLINE) {
            AppStorage.Set('statusColor', '#ffff0000')
          } else if (data.action == deviceManager.DeviceStateChangeAction.ONLINE) {
            AppStorage.Set('statusColor', '#ffffd500')
          }
        })
        console.info(logTag, 'deviceStateChange on successfully')
      } catch (error) {
        console.error(logTag, `deviceStateChange failed,error:${error.message}`)
      }
      // after intialize , start dicover device
      DistributedDeviceManager.startDeviceDiscovery()
    })
  }
  // 发起周边设备搜索; 上一次发现未结束，则返回Discovery Invalid
      static startDeviceDiscovery()
      {
        try {
          DistributedDeviceManager.subscribeID = Math.floor(Math.random() * 10000 + 1000)
          DistributedDeviceManager.pDeviceManager.startDeviceDiscovery({
            subscribeId: DistributedDeviceManager.subscribeID,
            mode: deviceManager.DiscoverMode.DISCOVER_MODE_ACTIVE,
            medium: deviceManager.ExchangeMedium.AUTO,
            freq: deviceManager.ExchangeFreq.HIGH,
            isWakeRemote: false,
            isSameAccount: false,
            capability: deviceManager.SubscribeCap.SUBSCRIBE_CAPABILITY_OSD
          })
          //设置回调监听，当发现时调用，并将发现的设备信息存储在
          //
          //
          // AppStorage中。
          DistributedDeviceManager.pDeviceManager.on('deviceFound', (data) => {
            console.info(logTag, 'device found')
            console.info(logTag, "deviceFound:" + JSON.stringify(data))
            // DistributedDeviceManager.distributedDeviceList = []
            if (DistributedDeviceManager.distributedDeviceList.length == 0) {
              DistributedDeviceManager.distributedDeviceList.push(data.device)
              AppStorage.Set('distributedDeviceList', DistributedDeviceManager.distributedDeviceList)
            } else {
              let length = 0
              DistributedDeviceManager.distributedDeviceList.forEach(element => {
                if (element.deviceId == data.device.deviceId) {
                  return
                }
                length++
              })
              if (length == DistributedDeviceManager.distributedDeviceList.length) {
                DistributedDeviceManager.distributedDeviceList.push(data.device)
                AppStorage.Set('distributedDeviceList', DistributedDeviceManager.distributedDeviceList)
              }
            }
          })
        } catch (error) {
          console.error(logTag, `startDeviceDiscovery failed,error:${error} ${error.message}`)
        }
      }
    // 进行设备认证
    static authenticateDevice(deviceInformation: deviceManager.DeviceInfo) {
      try {
        DistributedDeviceManager.pDeviceManager.authenticateDevice(deviceInformation, {
          authType: 1,
          extraInfo: undefined
        }, (error, data) => {
          if (error) {
            console.error(logTag, "authenticateDevice error:" + JSON.stringify(error.message))
            return
          }
          console.info(logTag, "authenticateDevice result:" + JSON.stringify(data))
        })
      } catch (error) {
        console.error(logTag, `authenticateDevice error:${JSON.stringify(error)}`)
      }
    }
  // 停止发现周边设备
  static stopDeviceDiscovery() {
    try {
      DistributedDeviceManager.pDeviceManager.stopDeviceDiscovery(DistributedDeviceManager.subscribeID)
    } catch (error) {

      console.error(logTag, `stopDeviceDiscovery failed,error:${JSON.stringify(error)}`)
    }
  }
  // 获得已认证设备列表，返回一个Array<DeviceInfo>.
  static getTrustedDeviceListSync() {
    return DistributedDeviceManager.pDeviceManager.getTrustedDeviceListSync()
  }
  // 解除设备认证
  static unAuthenticateDevice(deviceInformation: deviceManager.DeviceInfo) {
    DistributedDeviceManager.pDeviceManager.unAuthenticateDevice(deviceInformation)
  }
  // 释放资源
  static release() {
    DistributedDeviceManager.pDeviceManager.release()
  }
}