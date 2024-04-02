import router from '@ohos.router'
import { routerUserPage } from '../utils/routers';
import IconButton from './iconButton';

/*
 * 组件：页头
 * 使用：主要页面的页头
 * */
@Component
export default struct Header{
  @Prop title: string;
  @Prop iconUrl: Resource;

  build() {
    Stack() {
      Row() {
        Image(this.iconUrl)
          .width(40)
          .margin({left: 10})
          .onClick(() => {routerUserPage()})
        IconButton({iconUrl: $r('app.media.ic_public_search')})
      }
      .width("100%")
      .height("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      Text(this.title)
        .width("200vp")
        .height("60vp")
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
        .fontSize("20fp")
        .fontWeight(FontWeight.Bold)
    }
    .width("100%")
    .height("60")
    .backgroundColor($r('app.color.header_background'))
  }
}

/*
 * 组件：带返回的页头
 * 使用：内部页面的页头
 * */
@Component
export struct BackHeader{
  @Prop title: string;

  build() {
    Stack() {
      Row() {
        IconButton({iconUrl: $r('app.media.ic_public_arrow_left')})
          .onClick(() => {
            router.back();
          })
        IconButton({iconUrl: $r('app.media.ic_public_more_list')})
      }
      .width("100%")
      .height("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      Text(this.title)
        .width("200vp")
        .height("60vp")
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
        .fontSize("20fp")
        .fontWeight(FontWeight.Bold)
    }
    .width("100%")
    .height("60")
    .backgroundColor($r('app.color.header_background'))
  }
}