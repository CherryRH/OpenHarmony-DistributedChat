import relationalStore from '@ohos.data.relationalStore';

//此文件添加常量

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

//关系型数据库配置接口
export interface RDBConfig {
  name: string,
  securityLevel: relationalStore.SecurityLevel
}