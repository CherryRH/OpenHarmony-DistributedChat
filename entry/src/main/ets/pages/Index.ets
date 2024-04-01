import { ChatCard } from '../components/chatCard'
import Header from '../components/header'
import MoreButton from '../components/moreButton'

/*
 * 页面：主页
 * */
@Entry
@Component
struct Index {
  @State chatItems: ChatItem[] = []

  onPageShow() {
    //页面显示时加载数据
    this.chatItems.push(new ChatItem('聊天1'))
    this.chatItems.push(new ChatItem('聊天2'))
    this.chatItems.push(new ChatItem('聊天3'))
  }

  build() {
    //栈，重叠组件
    Stack() {
      //聊天主视图
      Column({space: 5}) {
        Header({title: 'Chat'})
        this.buildChatList()
      }
      .full()
      //功能界面

      //功能按钮
      MoreButton()
    }
    .full()
  }

  /*
   * 构建函数：构建聊天列表
   * */
  @Builder
  buildChatList() {
  List({space: 1}) {
    ForEach(
      this.chatItems,
      (item: ChatItem) => {
        ListItem() {
          ChatCard({name: item.name, ID: item.ID, iconUrl: item.iconUrl})
        }
      }
    )
  }
  .full()
  .alignListItem(ListItemAlign.Center)
}
}

/*
 * 类：聊天卡片对象
 * */
class ChatItem {
  ID: number;
  name: string;
  iconUrl: Resource;

  constructor(name: string, iconUrl?: Resource) {
    this.name = name;
    this.iconUrl = iconUrl ?? $r('app.media.ic_user_portrait');
    this.ID = 0;
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