import relationalStore from '@ohos.data.relationalStore';
import { BusinessError } from '@ohos.base';

/*
 * 类：聊天卡片对象（聊天列表信息对象）
 * */
export class ChatItem {
  ID: number;
  name: string;
  newMessage: string;
  iconUrl: Resource;
  time: Date; // 新增的时间属性

  constructor(name: string, newMessage?: string, time?: string, ID?: number) {
    this.name = name;
    this.iconUrl = $r('app.media.chatIcon_1');
    this.ID = ID ?? 0;
    this.newMessage = newMessage ?? '最新消息';
    this.time = time ? new Date(time) : new Date(); // 初始化时间属性，默认为当前时间
  }
}

/*
 * 数据库：储存聊天列表信息
 * 进入主页时加载，只存在一个文件
 * */
class ChatItemDB {
  private rdbStore: relationalStore.RdbStore | undefined = undefined;

  //关系型数据库配置
  static STORE_CONFIG: relationalStore.StoreConfig = {
    name: "ChatItem.db",
    securityLevel: relationalStore.SecurityLevel.S1
  };
  //数据库table名称
  static tableName: string = 'CHATITEMDB';
  //数据库各列数据名称
  static columnName: string[] = ['ID', 'NAME', 'NEWMESSAGE', 'TIME']
  //SQL语句
  static sql = `CREATE TABLE IF NOT EXISTS ${ChatItemDB.tableName} (
      ${ChatItemDB.columnName[0]} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ChatItemDB.columnName[1]} VARCHAR(255) NOT NULL,
      ${ChatItemDB.columnName[2]} TEXT NOT NULL,
      ${ChatItemDB.columnName[3]} VARCHAR(255)
      )`
  //日志Tag
  static logTag: string = 'ChatItemDBTestTag';

  //初始化
  initChatItemDB(context: Context) {
    relationalStore.getRdbStore(context, ChatItemDB.STORE_CONFIG, (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
      if (err) {
        console.error(ChatItemDB.logTag, '获取ChatItem.db失败', JSON.stringify(err));
        return;
      }
      rdbStore.executeSql(ChatItemDB.sql);
      console.info(ChatItemDB.logTag, '获取ChatItem.db成功');
      this.rdbStore = rdbStore;
    })
  }

  //获取聊天列表
  async getChatItems() {
    //构建查询条件
    let predicates = new relationalStore.RdbPredicates(ChatItemDB.tableName);
    try {
      //获取查询结果
      let result = await this.rdbStore!.query(predicates, ChatItemDB.columnName);
      //解析查询结果
      let chatItems: ChatItem[] = [];
      while (!result.isAtLastRow) {
        //初始在-1行，即表头，数据从第0行开始
        result.goToNextRow();
        //根据列序号获取数据
        let id = result.getLong(result.getColumnIndex(ChatItemDB.columnName[0]));
        let name = result.getString(result.getColumnIndex(ChatItemDB.columnName[1]));
        let newMessage = result.getString(result.getColumnIndex(ChatItemDB.columnName[2]));
        let time = result.getString(result.getColumnIndex(ChatItemDB.columnName[3]));
        chatItems.push(new ChatItem(name, newMessage, time, id));
      }
      result.close();
      console.info(ChatItemDB.logTag, '获取聊天列表成功');
      return chatItems;
    }
    catch (error) {
      console.error(ChatItemDB.logTag, '获取聊天列表失败', error);
      return [];
    }
  }

  //保存聊天列表
  async saveChatItems(chatItems: ChatItem[]) {
    if (!chatItems) {
      console.error(ChatItemDB.logTag, '聊天列表为空，保存停止');
      return;
    }
    for (let index = 0; index < chatItems.length; index++) {
      const element = chatItems[index];
      //构建查询条件
      let predicates = new relationalStore.RdbPredicates(ChatItemDB.tableName);
      predicates.equalTo(ChatItemDB.columnName[0], element.ID);
      let result: relationalStore.ResultSet = await this.rdbStore!.query(predicates, ChatItemDB.columnName);
      if (result.rowCount == 0) {
        //数据库中不存在，为新加入的聊天
        await this.addChatItem(element);
      }
      else {
        //数据库中存在，则覆盖旧聊天
        await this.updateChatItem(element.ID, element);
      }
    }
  }

  //增加聊天
  async addChatItem(chatItem: ChatItem) {
    try {
      await this.rdbStore!.insert(ChatItemDB.tableName, {name: chatItem.name, newMessage: chatItem.newMessage, time: chatItem.time.toString()});
      console.info(ChatItemDB.logTag, '增加聊天成功');
    }
    catch (error) {
      console.error(ChatItemDB.logTag, '增加聊天失败', error);
    }
  }

  //删除聊天
  async deleteChatItemByID(ID: number) {
    //删除条件
    let predicates = new relationalStore.RdbPredicates(ChatItemDB.tableName);
    predicates.equalTo(ChatItemDB.columnName[0], ID);
    //删除
    try {
      await this.rdbStore!.delete(predicates);
      console.info(ChatItemDB.logTag, '删除聊天成功');
    }
    catch (error) {
      console.error(ChatItemDB.logTag, '删除聊天失败', error);
    }
  }

  //更改聊天信息
  async updateChatItem(ID: number, chatItem: ChatItem) {
    //构建查询条件
    let predicates = new relationalStore.RdbPredicates(ChatItemDB.tableName);
    predicates.equalTo(ChatItemDB.columnName[0], ID);
    //更新数据
    try {
      await this.rdbStore!.update({name: chatItem.name, newMessage: chatItem.newMessage, time: chatItem.time.toString()}, predicates);
      console.info(ChatItemDB.logTag, '更改聊天信息成功');
    }
    catch (error) {
      console.error(ChatItemDB.logTag, '更改聊天信息失败', error);
    }
  }

  //查询聊天信息
  async getChatItemByID(ID: number) {
    //构建查询条件
    let predicates = new relationalStore.RdbPredicates(ChatItemDB.tableName);
    predicates.equalTo(ChatItemDB.columnName[0], ID);
    //获取并解析数据
    try {
      let result: relationalStore.ResultSet = await this.rdbStore!.query(predicates, ChatItemDB.columnName);
      if (result.rowCount == 0) {
        console.warn(ChatItemDB.logTag, '未查询到聊天');
        return null;
      }
      result.goToNextRow();
      let id = result.getLong(result.getColumnIndex(ChatItemDB.columnName[0]));
      let name = result.getString(result.getColumnIndex(ChatItemDB.columnName[1]));
      let newMessage = result.getString(result.getColumnIndex(ChatItemDB.columnName[2]));
      let time = result.getString(result.getColumnIndex(ChatItemDB.columnName[3]));
      result.close();
      let chatItem: ChatItem = new ChatItem(name, newMessage, time, id);
      console.info(ChatItemDB.logTag, '获取聊天成功');
      return chatItem;
    }
    catch (error) {
      console.error(ChatItemDB.logTag, '获取聊天失败', error);
      return null;
    }
  }

  //数据库是否可用
  isDefined() {
    return this.rdbStore != undefined;
  }

  //数据库是否为空
  async isEmpty(): Promise<boolean> {
    let predicates = new relationalStore.RdbPredicates(ChatItemDB.tableName);
    let result: relationalStore.ResultSet = await this.rdbStore!.query(predicates, ChatItemDB.columnName);
    return result.rowCount == 0;
  }

  //清空数据库
  async clear() {
    let predicates = new relationalStore.RdbPredicates(ChatItemDB.tableName);
    let result: relationalStore.ResultSet = await this.rdbStore!.query(predicates, ChatItemDB.columnName);
    for (let index = 1; index <= result.rowCount; index++) {
      result.goToNextRow();
      let id = result.getLong(result.getColumnIndex(ChatItemDB.columnName[0]));
      await this.deleteChatItemByID(id);
    }
  }
}

let chatItemDB: ChatItemDB = new ChatItemDB();
export default chatItemDB as ChatItemDB;