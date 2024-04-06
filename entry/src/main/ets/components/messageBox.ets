
/*
 * 组件：聊天信息泡
 * */
@Component
export default struct MessageBox {
  ID?: number = 0;
  @Prop iconUrl: Resource;
  @Prop message: string;
  @Prop username: string;
  @Prop time :Date
  @Prop isSelf :Boolean

  build() {
    if(!this.isSelf)
    GridRow()  {
      GridCol({ span: { sm: 12 } }) {
        GridRow() {
          GridCol({ span: { sm: 2 } }) {
            Row() {
              Image(this.iconUrl)
                .backgroundColor('#')
                .height('40')
                .width('40')
                .margin(5)
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Top)
          }

          GridCol({ span: { sm: 8} } ) {
            GridRow() {
              GridCol({ span: { sm: 12 } }) {
                Text(this.username)
                  .fontSize(10)
                  .alignSelf(ItemAlign.Start )
                  .padding(3)
              }

              GridCol({ span: { sm: 12 } }){
                Text(this.message)
                  .borderRadius(4)
                  .fontColor(Color.Black)
                  .backgroundColor(Color.White)
                  .width('95%')
                  .padding(10)
              }
            }

            .alignItems(12)
          }
          .padding(3)

        }
      }

    }.width('100%').height('auto')
    .padding(8)
    else
    GridRow()  {
      GridCol({ span: { sm: 12 } }) {
        GridRow() {

          GridCol({ span: { sm: 2} }) {}
          GridCol({ span: { sm: 8} } ) {
            GridRow() {
              GridCol({ span: { sm: 12 } }) {
                Text(this.username)
                  .fontSize(10)
                  .alignSelf(ItemAlign.End )
                  .padding(3)
             }

              GridCol({ span: { sm: 12 } }){
              Text(this.message)
                .borderRadius(4)
                .fontColor(Color.Black)
                .backgroundColor('#99ff00')
                .width('95%')
                .padding(10)
              }
            }

            .alignItems(12)
          }
          .padding(5)

          GridCol({ span: { sm: 2 } }) {
            Row() {
              Image(this.iconUrl)
                .backgroundColor('#')
                .height('40')
                .width('40')
                .margin(5)
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Top)
          }
        }
      }

    }.width('100%').height('auto')
    .padding(3)
  }


}

@Extend(Text)
function sub_font() {
  .fontSize(12)
  .fontColor(Color.Gray)
}