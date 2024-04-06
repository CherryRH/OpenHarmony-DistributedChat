import { BackHeader } from '../components/header';
import UserCard from '../components/userCard';
import user from '../data/User'

@Entry
@Component
struct UserPage {

  build() {
    Column({space: 10}) {
      BackHeader({title: '我的'})
      UserCard()
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