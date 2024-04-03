import relationalStore from '@ohos.data.relationalStore';
import {RDBConfig} from '../utils/common'

/*
 * 数据库：储存聊天列表信息
 * 进入主页时加载，只存在一个文件
 * */
class ChatItemDB {
  //关系型数据库配置
  private config: RDBConfig;

  constructor() {
    this.config = {
      name: 'ChatItem.db',
      securityLevel: relationalStore.SecurityLevel.S1
    }
  }

  //初始化数据库
  public init() {

  }

  //增加聊天
  public addChatItem(chatItem: ChatItem) {

  }

  //删除聊天
  public deleteChatItem(ID: number) {

  }

  //更改聊天信息
  public updateChatItem(ID: number, chatItem: ChatItem) {

  }

  //查询聊天信息
  public getChatItem(ID: number) {

  }
}

let chatItemDB: ChatItemDB = new ChatItemDB();

export default chatItemDB as ChatItemDB;

/*
 * 类：聊天卡片对象（聊天列表信息对象）
 * */
export class ChatItem {
  ID: number;
  name: string;
  newMessage: string;
  iconUrl: Resource;
  time: Date; // 新增的时间属性

  constructor(name: string) {
    this.name = name;
    this.iconUrl = $r('app.media.ic_user_portrait');
    this.ID = 0;
    this.newMessage = '最新消息';
    this.time = new Date(); // 初始化时间属性，默认为当前时间
  }
}