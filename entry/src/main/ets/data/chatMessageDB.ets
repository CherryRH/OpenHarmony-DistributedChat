import relationalStore from '@ohos.data.relationalStore';
import {RDBConfig} from '../utils/common'
import { avatars } from '../utils/common';

/*
 * 数据库：储存聊天记录
 * 进入聊天页面时加载，每个聊天建立一个文件
 * */
export default class ChatMessageDB {
  //关系型数据库配置
  private config: RDBConfig;

  constructor(ID: number) {
    this.config = {
      name: 'ChatMessage_' + ID.toString() + '.db',
      securityLevel: relationalStore.SecurityLevel.S1
    }
  }

  //初始化数据库
  public init() {

  }

  //增加信息
  public addChatMessage(chatMessage: ChatMessage) {

  }

  //删除信息
  public deleteChatMessage(ID: number) {

  }

  //更改信息
  public updateChatMessage(ID: number, chatMessage: ChatMessage) {

  }

  //查询聊天信息
  public getChatMessage(ID: number) {

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