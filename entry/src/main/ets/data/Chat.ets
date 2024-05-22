import user from './User'
import { avatars } from '../utils/common';

/*
 * 类：聊天
 * */
class Chat {
  private iconUrl: Resource;
  private name: string;
  private ID: number = 0;

  private chatMessages: ChatMessage[] = [];

  constructor(name: string, iconUrl?: Resource) {
    this.name = name;
    this.iconUrl = iconUrl ?? $r('app.media.ic_public_message');
  }

  public getIconUrl(): Resource {
    return this.iconUrl;
  }

  public getName(): string {
    return this.name;
  }

  public getID(): number {
    return this.ID;
  }

  public setID(ID: number) {
    return this.ID = ID;
  }

  //获取最新消息
  getNewChatMessage() {

  }

  //同步消息
  updateChatMessages() {

  }

  //发送消息
  sendChatMessage() {

  }
}

/*
 * 类：聊天消息对象
 * */
export class ChatMessage {
  ID: number;
  username : string;
  message: string;
  //用头像图片种类加载
  iconUrl: Resource;
  avatarUrlType: number;
  time: Date; // 新增的时间属性
  isSelf: Boolean

  constructor(username: string, message: string, isSelf: Boolean ,avatarUrlType?: number, time?: Date) {
    this.username = username;
    this.avatarUrlType = avatarUrlType ?? 0;
    this.iconUrl = avatars[this.avatarUrlType];
    this.ID = 0;
    this.time = time ?? new Date(); // 初始化时间属性，默认为当前时间
    this.message =  message
    this.isSelf = isSelf ?? false
  }
}

export default Chat