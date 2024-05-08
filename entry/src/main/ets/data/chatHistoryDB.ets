import relationalStore from '@ohos.data.relationalStore';
import { BusinessError } from '@ohos.base';
import { ChatMessage } from './Chat'

/*
 * 数据库：储存所有聊天的聊天记录
 * 进入主页时加载
 * */
export class ChatHistoryDB {
  private rdbStore: relationalStore.RdbStore | undefined = undefined;

  // 数据库table名称
  static tableName: string = 'CHATHISTORYDB';
  // 数据库各列数据名称
  static columnName: string[] = ['ID', 'CHATID', 'USERNAME', 'MESSAGE', 'ISSELF', 'AVATARURLTYPE', 'TIME'];

  // 日志Tag
  private logTag: string = 'ChatHistoryDBTestTag';

  // 关系型数据库配置
  static STORE_CONFIG: relationalStore.StoreConfig = {
    name: `ChatHistory.db`,
    securityLevel: relationalStore.SecurityLevel.S1
  };

  // SQL语句
  static sql = `CREATE TABLE IF NOT EXISTS ${ChatHistoryDB.tableName} (
        ${ChatHistoryDB.columnName[0]} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ChatHistoryDB.columnName[1]} INTEGER,
        ${ChatHistoryDB.columnName[2]} VARCHAR(255) NOT NULL,
        ${ChatHistoryDB.columnName[3]} TEXT NOT NULL,
        ${ChatHistoryDB.columnName[4]} bit,
        ${ChatHistoryDB.columnName[5]} INTEGER,
        ${ChatHistoryDB.columnName[6]} VARCHAR(255)
        )`

  // 初始化
  initChatHistoryDB(context: Context) {
    relationalStore.getRdbStore(context, ChatHistoryDB.STORE_CONFIG, (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
      if (err) {
        console.error(this.logTag, `获取ChatHistory.db失败`, JSON.stringify(err));
        return;
      }
      rdbStore.executeSql(ChatHistoryDB.sql);
      console.info(this.logTag, `获取ChatHistory.db成功`);
      this.rdbStore = rdbStore;
    })
  }

  // 获取全部聊天历史记录
  async getAllChatHistory() {
    // 构建查询条件
    let predicates = new relationalStore.RdbPredicates(ChatHistoryDB.tableName);
    try {
      // 获取查询结果
      let result = await this.rdbStore!.query(predicates, ChatHistoryDB.columnName);
      // 解析查询结果
      let chatMessages: ChatMessage[] = [];
      while (!result.isAtLastRow) {
        // 初始在-1行，即表头，数据从第0行开始
        result.goToNextRow();
        // 根据列序号获取数据
        let id = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[0]));
        let chatID = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[1]));
        let username = result.getString(result.getColumnIndex(ChatHistoryDB.columnName[2]));
        let message = result.getString(result.getColumnIndex(ChatHistoryDB.columnName[3]));
        let isSelf = Boolean(result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[4])));
        let avatarUrlType = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[5]));
        let time = result.getString(result.getColumnIndex(ChatHistoryDB.columnName[6]));
        let chatMessage: ChatMessage = new ChatMessage(chatID, username, message, isSelf, avatarUrlType, new Date(time));
        chatMessage.ID = id;
        chatMessages.push(chatMessage);
      }
      result.close();
      console.info(this.logTag, '获取全部聊天历史记录成功');
      return chatMessages;
    }
    catch (error) {
      console.error(this.logTag, '获取全部聊天历史记录失败', error);
      return [];
    }
  }

  // 获取一个聊天的聊天历史记录
  async getChatHistoryByChatID(chatID: number) {
    // 构建查询条件
    let predicates = new relationalStore.RdbPredicates(ChatHistoryDB.tableName);
    predicates.equalTo(ChatHistoryDB.columnName[1], chatID);
    try {
      // 获取查询结果
      let result = await this.rdbStore!.query(predicates, ChatHistoryDB.columnName);
      // 解析查询结果
      let chatMessages: ChatMessage[] = [];
      while (!result.isAtLastRow) {
        // 初始在-1行，即表头，数据从第0行开始
        result.goToNextRow();
        // 根据列序号获取数据
        let id = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[0]));
        let chatID = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[1]));
        let username = result.getString(result.getColumnIndex(ChatHistoryDB.columnName[2]));
        let message = result.getString(result.getColumnIndex(ChatHistoryDB.columnName[3]));
        let isSelf = Boolean(result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[4])));
        let avatarUrlType = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[5]));
        let time = result.getString(result.getColumnIndex(ChatHistoryDB.columnName[6]));
        let chatMessage: ChatMessage = new ChatMessage(chatID, username, message, isSelf, avatarUrlType, new Date(time));
        chatMessage.ID = id;
        chatMessages.push(chatMessage);
      }
      result.close();
      console.info(this.logTag, `获取聊天${chatID}历史记录成功`);
      return chatMessages;
    }
    catch (error) {
      console.error(this.logTag, `获取聊天${chatID}历史记录失败`, error);
      return [];
    }
  }

  // 保存聊天记录
  async saveChatHistory(chatMessages: ChatMessage[]) {
    if (!chatMessages) {
      console.error(this.logTag, '聊天历史记录为空，保存停止');
      return;
    }
    for (let index = 0; index < chatMessages.length; index++) {
      const element = chatMessages[index];
      // 构建查询条件
      let predicates = new relationalStore.RdbPredicates(ChatHistoryDB.tableName);
      predicates.equalTo(ChatHistoryDB.columnName[0], element.ID);
      let result: relationalStore.ResultSet = await this.rdbStore!.query(predicates, ChatHistoryDB.columnName);
      if (result.rowCount == 0) {
        // 数据库中不存在，为新加入的聊天记录
        await this.addChatMessage(element);
      }
      else {
        // 数据库中存在，则覆盖旧记录
        await this.updateChatMessage(element.ID, element);
      }
    }
  }

  // 增加一条聊天记录
  async addChatMessage(chatMessage: ChatMessage) {
    try {
      await this.rdbStore!.insert(ChatHistoryDB.tableName, {chatID: chatMessage.chatID, username: chatMessage.username, message: chatMessage.message
        , isSelf: Number(chatMessage.isSelf), avatarUrlType: chatMessage.avatarUrlType, time: chatMessage.time.toString()});
      console.info(this.logTag, '增加聊天记录成功');
    }
    catch (error) {
      console.error(this.logTag, '增加聊天记录失败', error);
    }
  }

  // 删除一条聊天记录
  async deleteChatMessageByID(ID: number) {
    // 删除条件
    let predicates = new relationalStore.RdbPredicates(ChatHistoryDB.tableName);
    predicates.equalTo(ChatHistoryDB.columnName[0], ID);
    // 删除
    try {
      await this.rdbStore!.delete(predicates);
      console.info(this.logTag, '删除聊天记录成功');
    }
    catch (error) {
      console.error(this.logTag, '删除聊天记录失败', error);
    }
  }

  // 更改聊天记录
  async updateChatMessage(ID: number, chatMessage: ChatMessage) {
    // 构建查询条件
    let predicates = new relationalStore.RdbPredicates(ChatHistoryDB.tableName);
    predicates.equalTo(ChatHistoryDB.columnName[0], ID);
    // 更新数据
    try {
      await this.rdbStore!.update({username: chatMessage.username, message: chatMessage.message
        , isSelf: Number(chatMessage.isSelf), avatarUrlType: chatMessage.avatarUrlType, time: chatMessage.time.toString()}, predicates);
      console.info(this.logTag, '更改聊天记录成功');
    }
    catch (error) {
      console.error(this.logTag, '更改聊天记录失败', error);
    }
  }

  // 查询一条聊天记录
  async getChatMessageByID(ID: number) {
    // 构建查询条件
    let predicates = new relationalStore.RdbPredicates(ChatHistoryDB.tableName);
    predicates.equalTo(ChatHistoryDB.columnName[0], ID);
    // 获取并解析数据
    try {
      let result: relationalStore.ResultSet = await this.rdbStore!.query(predicates, ChatHistoryDB.columnName);
      if (result.rowCount == 0) {
        console.warn(this.logTag, '未查询到聊天记录');
        return null;
      }
      result.goToNextRow();
      let id = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[0]));
      let chatID = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[1]));
      let username = result.getString(result.getColumnIndex(ChatHistoryDB.columnName[2]));
      let message = result.getString(result.getColumnIndex(ChatHistoryDB.columnName[3]));
      let isSelf = Boolean(result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[4])));
      let avatarUrlType = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[5]));
      let time = result.getString(result.getColumnIndex(ChatHistoryDB.columnName[6]));
      result.close();
      let chatMessage: ChatMessage = new ChatMessage(chatID, username, message, isSelf, avatarUrlType, new Date(time));
      chatMessage.ID = id;
      console.info(this.logTag, '获取聊天记录成功');
      return chatMessage;
    }
    catch (error) {
      console.error(this.logTag, '获取聊天记录失败', error);
      return null;
    }
  }

  // 数据库是否可用
  isDefined() {
    return this.rdbStore != undefined;
  }

  // 数据库是否为空
  async isEmpty(): Promise<boolean> {
    let predicates = new relationalStore.RdbPredicates(ChatHistoryDB.tableName);
    let result: relationalStore.ResultSet = await this.rdbStore!.query(predicates, ChatHistoryDB.columnName);
    return result.rowCount == 0;
  }

  // 清空数据库
  async clear() {
    let predicates = new relationalStore.RdbPredicates(ChatHistoryDB.tableName);
    let result: relationalStore.ResultSet = await this.rdbStore!.query(predicates, ChatHistoryDB.columnName);
    for (let index = 1; index <= result.rowCount; index++) {
      result.goToNextRow();
      let id = result.getLong(result.getColumnIndex(ChatHistoryDB.columnName[0]));
      await this.deleteChatMessageByID(id);
    }
  }
}

let chatHistoryDBs: ChatHistoryDB = new ChatHistoryDB();
export default chatHistoryDBs as ChatHistoryDB;
