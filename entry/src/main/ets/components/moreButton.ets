@Component
export default struct MoreButton {
  //按钮状态
  @State ifPushed: boolean = false;

  build() {
    Stack() {
      Button({stateEffect: false})
        .width(60)
        .backgroundColor($r('app.color.button_background'))
        .type(ButtonType.Circle)
        .shadow({ radius: 10, color: Color.Gray, offsetX: 6, offsetY: 4 })
      Image($r('app.media.ic_gallery_photoedit_more'))
        .width(30)
        .fillColor(Color.White)
    }
    .width(60)
    .position({x: '10%', y: '75%'})
    .clickEffect({level: ClickEffectLevel.HEAVY, scale: 0.7})
  }
}