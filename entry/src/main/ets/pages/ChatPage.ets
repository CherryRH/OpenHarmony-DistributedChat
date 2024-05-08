import router from '@ohos.router'
import ChatInput from '../components/chatInput';
import { BackHeader } from '../components/header'
import { PageInfo } from '../utils/routers';
import  MessageBox from "../components/messageBox"
import { ChatMessage } from '../data/Chat'
import user from '../data/User'
import logLibrary from '@ohos.logLibrary';
import chatHistoryDB, { ChatHistoryDB } from '../data/chatHistoryDB';

//获取路由传参
const params: PageInfo = router.getParams() as PageInfo;

const logTag: string = 'ChatPageTag';

@Entry
@Component
struct ChatPage {
  private chatID: number = 0;

  @State messageStr: string = '';

  //滚动条设置
  scroller: Scroller = new Scroller();

  //聊天列表元素数组
  @State chatMessages: ChatMessage[] = []

  async onPageShow() {
    this.chatID = params.id;
    // 读取历史记录，如果是预览器就加入一些预览信息
    if (!chatHistoryDB.isDefined()) {
      //预览器数据
      if (this.chatMessages.length === 0) {
        this.chatMessages.push(new ChatMessage(this.chatID, '用户1' , '你怎么知道我今天十连三金' , true))
        this.chatMessages.push(new ChatMessage(this.chatID, '用户6' , '狗托？？', false))
        this.chatMessages.push(new ChatMessage(this.chatID, '用户2' , '？？？？？？？？？' , false))
        this.chatMessages.push(new ChatMessage(this.chatID, '用户3' , '告诉我是假的吧', false))
        this.chatMessages.push(new ChatMessage(this.chatID, '用户4' , '阳寿借我点', false))
        this.chatMessages.push(new ChatMessage(this.chatID, '用户2' , '知子莫若父', false))
        this.chatMessages.push(new ChatMessage(this.chatID, '用户5' , '首先我没破防，就是我有个朋友是这样的，他就和你说的一样，但他不是那样的，我觉得你这样真的没意思，你就算发了他们也不会破防，因为我朋友是这样的所以我知道，我劝你最好删了，因为我朋友就算看了也不会破防，所以你这句话留着也没啥用，还不如删了，然后就是我没破防，只是我朋友是那样的，我提替我朋友说话，我没破防，我就是提醒一下你，记得把这句话删了，我可没破防。', false) )
      }
      //设置聊天的ID
      for (let index = 0; index < this.chatMessages.length; index++) {
        const element = this.chatMessages[index];
        element.ID = index + 1;
      }
      console.warn(logTag, '聊天历史记录数据库未加载（可能在使用预览器）')
    }
    else {
      if (this.chatMessages.length === 0) {
        //数据库数据
        this.chatMessages = await chatHistoryDB.getChatHistoryByChatID(this.chatID);
      }
    }

    this.scroller.scrollToIndex(this.chatMessages.length - 1);
  }

  async onPageHide() {
    // 保存聊天记录
    await chatHistoryDB.saveChatHistory(this.chatMessages);
  }

  handleMessageSend = () => {
    if(this.messageStr == "") return;
    let newMessage: ChatMessage = new ChatMessage(this.chatID, user.getName(), this.messageStr, true, user.getAvatarType());
    console.log(logTag, newMessage.chatID);
    this.chatMessages.push(newMessage);
    this.messageStr = "";
    this.scroller.scrollToIndex(this.chatMessages.length - 1);
  }

  build() {
    Column() {
      BackHeader({title: params.name + params.id.toString()})
      Row({space: 5}){
        List({space: 6, scroller: this.scroller}) {
          ForEach(
            this.chatMessages,
            (item: ChatMessage) => {
              ListItem() {
                MessageBox({message: item.message, username: item.username, ID: item.ID, iconUrl: item.iconUrl , time:item.time , isSelf:item.isSelf})
              }
            }
          )
        }
      }
      .height('83%')
      ChatInput({messageStr: this.messageStr, handleMessageSend: this.handleMessageSend})
    }
    .full()
    .backgroundColor("#F5F5F5")
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

/*
 * 样式表：占满空间
 * */
@Styles
function full() {
  .width('100%')
  .height('100%')
}