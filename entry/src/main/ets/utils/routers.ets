import router from '@ohos.router'

//路由函数的封装
export default function routerIndexPage() {
  router.pushUrl(
    {
      url: 'pages/Index',
      params: new PageInfo(0)
    },
    router.RouterMode.Single,
    Error => {
      if (Error) {
        console.log('Router to ' + '/pages/Index' + ' failed.');
      }
    }
  )
}

export function routerUserPage() {
  router.pushUrl(
    {
      url: 'pages/UserPage',
      params: new PageInfo(-1)
    },
    router.RouterMode.Single,
    Error => {
      if (Error) {
        console.log('Router to ' + '/pages/UserPage' + ' failed.');
      }
    }
  )
}

export function routerChatPage(chatID: number, chatName: string) {
  router.pushUrl(
    {
      url: 'pages/ChatPage',
      params: new PageInfo(chatID, chatName)
    },
    router.RouterMode.Single,
    Error => {
      if (Error) {
        console.log('Router to ' + '/pages/ChatPage' + ' failed.');
      }
    }
  )
}

/*
 * 页面路由传参对象
 * */
export class PageInfo {
  id: number
  name: string
  constructor(id?: number, name?: string) {
    this.id = id ?? 0;
    this.name = name ?? '';
  }
}