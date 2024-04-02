import { BackHeader } from '../components/header';
import UserCard from '../components/userCard';
import user from '../data/User'

@Entry
@Component
struct UserPage {
  @State userName: string = user.getName();
  @State userID: string = user.getId();
  @State avatarType: number = user.getAvatarType();

  @State ifEdit: boolean = false;

  build() {
    Column({space: 10}) {
      BackHeader({title: '我的'})
      UserCard({username: this.userName, userID: this.userID, avatarType: this.avatarType, ifEdit: this.ifEdit})
    }
    .full()
    .justifyContent(FlexAlign.Start)
  }
}

/*
 * 样式表：占满空间
 * */
@Styles
function full() {
  .width('100%')
  .height('100%')
}