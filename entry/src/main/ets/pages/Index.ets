import { ChatCard } from '../components/chatCard'

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
  }

  build() {
    Column() {
      this.buildChatList()
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