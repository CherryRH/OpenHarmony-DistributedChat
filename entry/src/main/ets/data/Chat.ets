import user from './User'
import { avatars } from '../utils/common';

/*
 * 类：聊天
 * 用法：程序运行时作为聊天的缓存，并实现分布式数据库与本地缓存的交互
 * */
export default class Chat {
  private iconUrl: Resource;
  private name: string;
  private ID: number = 0;
  // 聊天记录
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
  // 所属聊天的ID
  chatID: number;
  username : string;
  message: string;
  // 用头像图片种类加载
  iconUrl: Resource;
  avatarUrlType: number;
  time: Date; // 新增的时间属性
  isSelf: Boolean

  constructor(chatID: number, username: string, message: string, isSelf: Boolean ,avatarUrlType?: number, time?: Date) {
    this.chatID = chatID;
    this.username = username;
    this.avatarUrlType = avatarUrlType ?? 0;
    this.iconUrl = avatars[this.avatarUrlType];
    this.ID = 0;
    this.time = time ?? new Date(); // 初始化时间属性，默认为当前时间
    this.message =  message
    this.isSelf = isSelf ?? false
  }
}