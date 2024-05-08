import { ChatCard } from '../components/chatCard'
import Header from '../components/header'
import MoreButton from '../components/moreButton'
import SideBar from '../components/sideBar'
import abilityAccessCtrl , {Permissions}from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import { requestPermission } from '../distributed_capability/RequestPermission'
import user from '../data/User'
import { ChatItem } from '../data/chatItemDB'
import chatItemDB from '../data/chatItemDB'
import { getNowTime } from '../utils/common'
import chatHistoryDB from '../data/chatHistoryDB'
import { ChatMessage } from '../data/Chat'

const logTag: string = 'IndexTestTag';

/*
 * 页面：主页
 * */
@Entry
@Component
struct Index {
  //页头用户头像
  @State avatarUrl: Resource = user.getAvatarUrl();
  //聊天列表元素数组
  @State chatItems: ChatItem[] = []
  //侧边栏是否展开
  @State ifSideBarUnfold: boolean = false;
  //侧边栏x偏移
  @State xOffset: string = '-100%';

  async aboutToAppear() {
    //加载用户数据
    await user.loadUser();
    this.avatarUrl = user.getAvatarUrl();
    //加载聊天列表数据
    if (!chatItemDB.isDefined()) {
      //预览器数据
      if (this.chatItems.length == 0) {
        for (let index = 0; index < 3; index++) {
          this.chatItems.push(new ChatItem(`聊天${index + 1}（预览器）`, '最新消息', getNowTime(), index));
        }
      }
      console.warn(logTag, '聊天列表数据库未加载（可能在使用预览器）')
    }
    else {
      //如果数据库为空，则初始化几个聊天
      if (await chatItemDB.isEmpty()) {
        await chatItemDB.addChatItem(new ChatItem('聊天', '最新消息', getNowTime()));
        await chatItemDB.addChatItem(new ChatItem('聊天', '最新消息', getNowTime()));
        await chatItemDB.addChatItem(new ChatItem('聊天', '最新消息', getNowTime()));
      }
      //数据库数据
      this.chatItems = await chatItemDB.getChatItems();
      // 初始化历史记录，如果数据库为空，则加入几条信息
      if (await chatHistoryDB.isEmpty()) {
        for (let i = 0; i < this.chatItems.length; i++) {
          await chatHistoryDB.addChatMessage(new ChatMessage(this.chatItems[i].ID, '门酱', '我要玩原神' , false));
          await chatHistoryDB.addChatMessage(new ChatMessage(this.chatItems[i].ID, '大伟哥', '玩原神玩的' , false));
        }
      }
    }
  }

  onPageShow() {
    //加载用户数据
    this.avatarUrl = user.getAvatarUrl();
  }
  // when entry , request the permission

  build() {
    //栈，重叠组件
    Stack() {
      //聊天主视图
      Column({space: 5}) {
        Header({title: 'Chat', iconUrl: this.avatarUrl})
        this.buildChatList()
      }
      .full()
      //侧边栏
      SideBar()
        .offset({x: this.xOffset})
      //功能按钮
      MoreButton({ifPushed: this.ifSideBarUnfold})
        .position({x: '10%', y: '80%'})
        .onClick(() => {
          //实现侧边栏的展开以及动画效果
          this.ifSideBarUnfold = !this.ifSideBarUnfold;
          animateTo({duration: 300, curve: Curve.Rhythm}, () => {
            this.xOffset = this.ifSideBarUnfold ? '-10%' : '-100%';
          })
        })
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
            ChatCard({name: item.name, ID: item.ID, iconUrl: item.iconUrl, time:item.time, newMessage: item.newMessage})
          }
        }
      )
    }
    .width('100%')
    .height('90%')
    .alignListItem(ListItemAlign.Center)
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