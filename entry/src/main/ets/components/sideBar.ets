
// xxx.ets
import web_webview from '@ohos.web.webview'
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


@Component
struct WebComponent {
  controller: web_webview.WebviewController = new web_webview.WebviewController()
  build() {
    Column() {
      Web({ src: 'https://ys.mihoyo.com', controller: this.controller })
        .imageAccess(true)
        .height("100%")
    }
  }
}