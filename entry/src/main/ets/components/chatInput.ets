/*
 *组件：聊天输入组件
 * */
@Component
export default struct ChatInput {
  @Link messageStr: string;

  build() {
    Column() {
      Row() {
        TextInput()
      }
    }
    .width('100%')
    .height(40)
  }
}