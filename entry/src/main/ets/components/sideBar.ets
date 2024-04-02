@Component
export default struct SideBar {

  build() {
    Column() {

    }
    .bar_card()
  }
}

@Styles
function bar_card() {
  .width('90%')
  .height('100%')
  .borderRadius(20)
  .backgroundColor(Color.White)
  .shadow({ radius: 20, color: Color.Gray, offsetX: 15, offsetY: 10 })
}