import { ChatCard } from '../components/chatCard'
import Header from '../components/header'
import MoreButton from '../components/moreButton'
import SideBar from '../components/sideBar'
import abilityAccessCtrl , {Permissions}from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import { requestPermission } from '../distributed_capability/RequestPermission'
import user from '../data/User'
import preferenceUtil from '../utils/UserPreferenceUtil'
import userPrefName, {userPrefKeys} from '../utils/common'
import {ChatItem} from '../data/chatItemDB'
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

  async onPageShow() {
    //加载用户数据
    let userName = await preferenceUtil.getPereferenceValue(userPrefName, userPrefKeys.get('userName'), user.getName());
    let userID = await preferenceUtil.getPereferenceValue(userPrefName, userPrefKeys.get('userID'), user.getId());
    let avatarType = await preferenceUtil.getPereferenceValue(userPrefName, userPrefKeys.get('avatarUrlType'), user.getAvatarType());
    user.setName(userName as string);
    user.setID(userID as string);
    user.setAvatarType(avatarType as number);
    this.avatarUrl = user.getAvatarUrl();
    //页面显示时加载聊天数据
    if (this.chatItems.length === 0) {
      this.chatItems.push(new ChatItem('聊天1'))
      this.chatItems.push(new ChatItem('聊天2'))
      this.chatItems.push(new ChatItem('聊天3'))
      this.chatItems.push(new ChatItem('聊天4'))
    }
    //设置聊天的ID
    for (let index = 0; index < this.chatItems.length; index++) {
      const element = this.chatItems[index];
      element.ID = index + 1;
    }
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
    .full()
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