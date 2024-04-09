/*
 *组件：聊天输入组件
 * */
@Component
export default struct ChatInput {
  @Link messageStr: string;

  handleMessageSend = () => {}

  build() {
    Column() {
      Row({space: 10}) {
        TextInput({text: this.messageStr})
          .backgroundColor(Color.White)
          .shadow({ radius: 10, color: Color.Gray, offsetX: 6, offsetY: 4 })
          .layoutWeight(5)
          .onChange((val: string) => {
            this.messageStr = val;
          })
        Button('发送')
          .layoutWeight(1)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {this.handleMessageSend()})
      }
      .width('100%')
      .padding(3)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .backgroundColor($r('app.color.card_background'))
    .padding(5)
    .justifyContent(FlexAlign.Center)
  }
}