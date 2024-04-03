import { avatars } from '../utils/common';

/*
 * 类：用户
 * */
export class User {
  private userID: string;
  private name: string;
  private avatarUrl: Resource = $r('app.media.ic_user_portrait');
  private avatarType: number;

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
}

//导出User实例（本机用户）
let user: User = new User();

export default user as User