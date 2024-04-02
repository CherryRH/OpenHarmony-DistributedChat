import router from '@ohos.router'
import { routerUserPage } from '../utils/routers';

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
        Image($r('app.media.ic_public_search'))
          .width(25)
          .margin({right: 10})
      }
      .width("100%")
      .height("100%")
      .padding(5)
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
        Row({space:15}) {
          Image($r('app.media.ic_public_arrow_left'))
            .width(25)
            .onClick(() => {
              router.back();
            })
        }
        .padding(10)
        Row({space:15}) {
          Image($r('app.media.ic_public_more_list'))
            .width(25)
        }
        .padding(10)
      }
      .width("100%")
      .height("100%")
      .padding(5)
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