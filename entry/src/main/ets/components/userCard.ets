import user from '../data/User';
import { avatars, userPrefKeys } from '../utils/common';
import preferenceUtil from '../utils/UserPreferenceUtil'
import userPrefName from '../utils/common'

/*
 * 组件：用户卡片
 * 使用：在用户界面显示用户卡片
 * */
@Component
export default struct UserCard {
  @State username: string = user.getName();
  @State avatarType: number = user.getAvatarType();
  @State avatarUrl: Resource = user.getAvatarUrl();
  @State userID: string = user.getId();

  @State ifEdit: boolean = false;
  @State yOffset: string = '-30%';

  build() {
    Column() {
      Column() {
        Row({space: 15}) {
          Image(this.avatarUrl)
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
          if (!this.ifEdit) {
            Button('编辑')
              .backgroundColor($r('app.color.button_background'))
              .clickEffect({level: ClickEffectLevel.HEAVY, scale: 0.7})
              .onClick(() => {
                //打开编辑栏
                animateTo({duration: 300, curve: Curve.Rhythm}, () => {
                  this.yOffset = '0%';
                  this.ifEdit = true;
                })
              })
          }
        }
        .width('100%')
      }
      .width('97%')
      .height(150)
      .padding(15)
      .borderRadius(10)
      .justifyContent(FlexAlign.SpaceBetween)
      .shadow({ radius: 10, color: Color.Gray, offsetX: 6, offsetY: 4 })

      //编辑栏
      if (this.ifEdit) {
        Column({space: 10}) {
          Row() {
            Text('头像：')
              .layoutWeight(2)
            List({space: 10}) {
              ForEach(
                avatars,
                (item: Resource, index: number) => {
                  ListItem() {
                    Image(item)
                      .width(60)
                      .borderRadius(10)
                      .clickEffect({level: ClickEffectLevel.HEAVY, scale: 0.7})
                      .onClick(() => {
                        //更改头像
                        user.setAvatarType(index);
                        this.avatarType = index;
                        this.avatarUrl = item;
                      })
                  }
                }
              )
            }
            .height(80)
            .alignListItem(ListItemAlign.Center)
            .listDirection(Axis.Horizontal)
            .layoutWeight(7)
          }
          Row() {
            Text('用户名：')
              .layoutWeight(2)
            TextInput({text: this.username})
              .layoutWeight(7)
              .onChange((val: string) => {
                this.username = val;
              })
          }
          Row() {
            Text('ID：')
              .layoutWeight(2)
            TextInput({text: this.userID})
              .layoutWeight(7)
              .onChange((val: string) => {
                this.userID = val;
              })
          }
          Row() {
            Blank()
            Button('保存')
              .backgroundColor($r('app.color.button_background'))
              .clickEffect({level: ClickEffectLevel.HEAVY, scale: 0.7})
              .onClick(async () => {
                //判断是否为空
                if (this.username === '' || this.userID === '') {
                  AlertDialog.show({
                    message: '用户名和ID不能为空喵~'
                  })
                  return;
                }
                //收起编辑栏
                animateTo({duration: 300, curve: Curve.Rhythm}, () => {
                  this.yOffset = '-30%';
                  this.ifEdit = false;
                })
                //保存用户信息
                user.setName(this.username);
                user.setID(this.userID);
                //保存用户信息到首选项
                user.saveUser();
              })
          }
          .width('100%')
        }
        .width('97%')
        .padding(15)
        .margin({top: 10, bottom: 10})
        .borderRadius(10)
        .offset({y: this.yOffset})
        .shadow({ radius: 10, color: Color.Gray, offsetX: 6, offsetY: 4 })
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
  }
}