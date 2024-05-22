import router from '@ohos.router'
import ChatInput from '../components/chatInput';
import { BackHeader } from '../components/header'
import { PageInfo } from '../utils/routers';
import  MessageBox from "../components/messageBox"
import {ChatMessage} from '../data/chatMessageDB'
import user from '../data/User'
import logLibrary from '@ohos.logLibrary';
import SendManager from '../distributed_capability/SendManager'
import { DistributedDeviceManager } from '../distributed_capability/DistibutedFunctions';
import { ReceivedMessageList } from '../distributed_capability/ReceivedMessages';

//获取路由传参
const params: PageInfo = router.getParams() as PageInfo;

@Entry
@Component
struct ChatPage {
  @State messageStr: string = '';

  //滚动条设置
  scroller: Scroller = new Scroller();

  //聊天列表元素数组
  @State chatMessages: ChatMessage[] = []

  async onPageShow() {
    if (this.chatMessages.length === 0) {
      this.chatMessages.push(new ChatMessage('用户1' , '你怎么知道我今天十连三金' , true))
      this.chatMessages.push(new ChatMessage('用户6' , '狗托？？', false))
      this.chatMessages.push(new ChatMessage('用户2' , '？？？？？？？？？' , false))
      this.chatMessages.push(new ChatMessage('用户3' , '告诉我是假的吧', false))
      this.chatMessages.push(new ChatMessage('用户4' , '阳寿借我点', false))
      this.chatMessages.push(new ChatMessage('用户2' , '知子莫若父', false))
      this.chatMessages.push(new ChatMessage('用户5' , '首先我没破防，就是我有个朋友是这样的，他就和你说的一样，但他不是那样的，我觉得你这样真的没意思，你就算发了他们也不会破防，因为我朋友是这样的所以我知道，我劝你最好删了，因为我朋友就算看了也不会破防，所以你这句话留着也没啥用，还不如删了，然后就是我没破防，只是我朋友是那样的，我提替我朋友说话，我没破防，我就是提醒一下你，记得把这句话删了，我可没破防。', false) )
    }

    this.scroller.scrollToIndex(this.chatMessages.length - 1);

    //设置聊天的ID
    for (let index = 0; index < this.chatMessages.length; index++) {
      const element = this.chatMessages[index];
      element.ID = index + 1;
    }
    // 测试时使用的receive回调函数
    ReceivedMessageList.onReceiveMessage((message:string , sender:string):void=>
    {
      console.log(`Get the callback : ${message} from ${sender}`);
    })
  }

  handleMessageSend = () => {
    if(this.messageStr == "") return;
    this.chatMessages.push(new ChatMessage(user.getName(), this.messageStr, true , user.getAvatarType()))
    //  测试时使用的给自己发消息的测试函数，可以作为使用示例。真实场景下应使用DDM中的设备List的NetworkID进行发送。
    SendManager.SendMessage(DistributedDeviceManager.localDeviceNetId,this.messageStr)

    this.messageStr = ""
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