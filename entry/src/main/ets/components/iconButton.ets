
/*
 * 组件：图标按钮
 * */
@Component
export default struct IconButton {
  @Prop iconUrl: Resource;

  build() {
    Stack() {
      Button({stateEffect: false})
        .width(40)
        .type(ButtonType.Circle)
        .backgroundColor(Color.Transparent)
      //图标
      Image(this.iconUrl)
        .width(30)
    }
    .width(60)
    .clickEffect({level: ClickEffectLevel.HEAVY, scale: 0.7})
  }
}