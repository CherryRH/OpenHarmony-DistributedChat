
/*
 * 组件：主页控制侧边栏的更多按钮
 * */
@Component
export default struct MoreButton {
  //按钮状态
  @Link ifPushed: boolean;

  build() {
    Stack() {
      Button({stateEffect: false})
        .width(60)
        .backgroundColor($r('app.color.button_background'))
        .type(ButtonType.Circle)
        .shadow({ radius: 10, color: Color.Gray, offsetX: 6, offsetY: 4 })
      //图标
      Image(this.ifPushed ? $r('app.media.ic_public_arrow_left') : $r('app.media.ic_gallery_photoedit_more'))
        .width(30)
        .fillColor(Color.White)
    }
    .width(60)
    .clickEffect({level: ClickEffectLevel.HEAVY, scale: 0.7})
  }
}