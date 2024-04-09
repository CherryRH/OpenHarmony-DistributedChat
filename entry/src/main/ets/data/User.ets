import userPrefName, { avatars, userPrefKeys } from '../utils/common';
import preferenceUtil from '../utils/UserPreferenceUtil';

/*
 * 类：用户
 * */
export class User {
  private userID: string;
  private name: string;
  private avatarUrl: Resource = $r('app.media.ic_user_portrait');
  private avatarType: number;

  private logTag: string = 'UserTag';

  constructor(userID?: string, userName?: string, avatarType?: number) {
    this.userID = userID ?? 'User@unknown.com';
    this.name = userName ?? 'User';
    this.avatarType = avatarType ?? 0;
    this.setAvatarType(this.avatarType);
  }

  public getId(): string {
    return this.userID;
  }

  public getName(): string {
    return this.name;
  }

  public getAvatarUrl(): Resource {
    return this.avatarUrl;
  }

  public getAvatarType(): number {
    return this.avatarType;
  }

  public setName(username: string) {
    this.name = username;
  }

  public setID(userID: string) {
    this.userID = userID;
  }

  public setAvatarType(avatarType: number) {
    this.avatarType = avatarType;
    if (avatarType >= 0 && avatarType <= avatars.length) {
      this.avatarUrl = avatars[avatarType];
    }
    else this.avatarUrl = avatars[0];
  }

  //从用户首选项加载信息
  async loadUser() {
    if (preferenceUtil.isLoaded(userPrefName)) {
      //从首选项加载
      let userName = await preferenceUtil.getPereferenceValue(userPrefName, userPrefKeys.get('userName'), 'User');
      let userID = await preferenceUtil.getPereferenceValue(userPrefName, userPrefKeys.get('userID'), 'User@unknown.com');
      let avatarType = await preferenceUtil.getPereferenceValue(userPrefName, userPrefKeys.get('avatarUrlType'), 0);
      this.setName(userName as string);
      this.setID(userID as string);
      this.setAvatarType(avatarType as number);
    }
    else {
      console.warn(this.logTag, '用户首选项未加载（可能在使用预览器）');
    }
  }

  //保存到用户首选项
  async saveUser() {
    if (preferenceUtil.isLoaded(userPrefName)) {
      await preferenceUtil.putPereferenceValue(userPrefName, userPrefKeys.get('userName'), this.name);
      await preferenceUtil.putPereferenceValue(userPrefName, userPrefKeys.get('userID'), this.userID);
      await preferenceUtil.putPereferenceValue(userPrefName, userPrefKeys.get('avatarUrlType'), this.avatarType);
    }
    else {
      console.warn(this.logTag, '用户首选项未加载（可能在使用预览器）');
    }
  }
}

//导出User实例（本机用户）
let user: User = new User();

export default user as User