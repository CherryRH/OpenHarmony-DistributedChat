import { IconType } from '@ohos.arkui.advanced.ComposeListItem';
import { routerChatPage } from '../utils/routers';

/*
 * 类：时间类
 * */
class Time {
  hours: number;
  minutes: number;

  constructor(hours: number = 0, minutes: number = 0) {
    this.hours = hours;
    this.minutes = minutes;
  }
}

/*
 * 组件：聊天卡片
 * 使用：显示一个聊天卡片
 * */
@Component
export struct ChatCard {
  ID?: number = 0;
  @Prop name: string;
  @Prop iconUrl: Resource;
  @Prop time: Date;

  build() {
    Row({space: 15}) {
      Image(this.iconUrl)
        .height('100%')
      Column() {
        Text(this.name)
        Blank()
        Text('最新消息')
          .sub_font()
      }
      .layoutWeight(4)
      .height('90%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      Column() {
        Text(this.time.getHours().toString() + ":" +this.time.getMinutes().toString())
          .sub_font()
      }
      .layoutWeight(1)
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.End)
    }
    .width('97%')
    .height(80)
    .padding(15)
    .borderRadius(10)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .alignSelf(ItemAlign.Center)
    .shadow({ radius: 10, color: Color.Gray, offsetX: 6, offsetY: 4 })
    .clickEffect({level: ClickEffectLevel.HEAVY, scale: 0.9})
    .onClick(() => {
      routerChatPage(this.ID);
    })
  }
}

@Extend(Text)
function sub_font() {
  .fontSize(12)
  .fontColor(Color.Gray)
}