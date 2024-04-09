import relationalStore from '@ohos.data.relationalStore';

//此文件添加常量和辅助函数等

//用户首选项文件名称
const userPrefName: string = 'UserPreference';

export default userPrefName;
//用户首选项key值
export const userPrefKeys = new Map<string, string>([
  ['userName', 'USERNAME'],
  ['userID', 'USERID'],
  ['avatarUrlType', 'AVATARURLTYPE']
]);

//用户头像列表
export const avatars: Resource[] = [
  $r('app.media.ic_user_portrait'),
  $r('app.media.avatar_1'),
  $r('app.media.avatar_2'),
  $r('app.media.avatar_3')
]

//获取当前时间字符串
export function getNowTime() {
  let date: Date = new Date();
  return date.toString();
}