import { IconType } from '@ohos.arkui.advanced.ComposeListItem';

/*
 * 组件：聊天卡片
 * 使用：显示一个聊天卡片
 * */
@Component
export struct ChatCard {
  ID?: number = 0;
  @Prop name: string;
  @Prop iconUrl: Resource;

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
        Text('时间')
          .sub_font()
      }
      .layoutWeight(1)
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.End)
    }
    .width('100%')
    .height(80)
    .padding(15)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.card_background'))
  }
}

@Extend(Text)
function sub_font() {
  .fontSize(12)
  .fontColor(Color.Gray)
}