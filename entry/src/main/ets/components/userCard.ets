import user from '../data/User';

/*
 * 组件：我的卡片
 * 使用：显示我的用户卡片
 * */
@Component
export default struct UserCard {
  @Link username: string;
  @Link avatarType: number;
  @Link userID: string;

  @Link ifEdit: boolean;

  build() {
    Column() {
      Row({space: 15}) {
        Image(user.getAvatarUrl())
          .width(60)
          .borderRadius(10)
        Column() {
          Text(this.username)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
          Text(this.userID)
        }
        .height(60)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      Row() {
        Blank()
        Button('编辑')
          .backgroundColor($r('app.color.button_background'))
      }
      .width('100%')
    }
    .width('97%')
    .height(150)
    .padding(15)
    .borderRadius(10)
    .justifyContent(FlexAlign.SpaceBetween)
    .shadow({ radius: 10, color: Color.Gray, offsetX: 6, offsetY: 4 })
  }
}