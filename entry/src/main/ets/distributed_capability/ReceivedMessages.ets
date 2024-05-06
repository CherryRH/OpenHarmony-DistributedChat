import ChatDataStore from './DistributedDataStore'
import {DistributedDeviceManager} from './DistibutedFunctions'
import { BusinessError } from '@ohos.base';
const logTag: string = '[ReceivedMessagesTestTag]';
// 用于存储消息的实例类
export class ReceivedMessage
{

  message : string ;
  sender : string ;       // record the sender's network ID
  constructor(message:string , sender:string)
  {
    this.message = message ;
    this.sender = sender ;
  }
}
// 这个类用来接收所有收到但还未处理的消息，提供接口进行创建与处理消息
export class ReceivedMessageList
{
  static Messages:ReceivedMessage[] = [];

  // it will return the most recently received message
  static PopMessage():ReceivedMessage | undefined
  {
    return ReceivedMessageList.Messages.pop() ;
  }
  // 暂存接收到的新消息
  static NewMessage(message:string , sender:string):void
  {
    let tem : ReceivedMessage = new ReceivedMessage(message,sender) ;
    ReceivedMessageList.Messages.push(tem) ;
  }
}