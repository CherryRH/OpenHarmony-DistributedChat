import router from '@ohos.router'
import ChatInput from '../components/chatInput';
import { BackHeader } from '../components/header'
import { PageInfo } from '../utils/routers';

//获取路由传参
const params: PageInfo = router.getParams() as PageInfo;

@Entry
@Component
struct ChatPage {
  @State messageStr: string = '';

  build() {
    Column() {
      BackHeader({title: '聊天' + params.id})
      ChatInput({messageStr: this.messageStr})
    }
    .full()
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