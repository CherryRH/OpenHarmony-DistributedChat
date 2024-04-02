
/*
 * 类：用户
 * */
export class User {
  private userID: string;
  private name: string;
  private avatarUrl: Resource;
  private avatarType: number;

  constructor(userID?: string, userName?: string, avatarUrl?: Resource) {
    this.userID = userID ?? 'User@unknown.com';
    this.name = userName ?? 'User';
    this.avatarUrl = avatarUrl ?? $r('app.media.ic_user_portrait');
    this.avatarType = -1;
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

  public setAvatarUrl(avatarUrl: Resource) {
    this.avatarUrl = avatarUrl;
  }

  public setAvatarType(avatarType: number) {
    this.avatarType = avatarType;
    switch (avatarType) {
      case 0: {
        this.avatarUrl = $r('app.media.ic_user_portrait');
        break;
      }
      case 1: {
        this.avatarUrl = $r('app.media.avatar_1');
        break;
      }
      case 2: {
        this.avatarUrl = $r('app.media.avatar_2');
        break;
      }
      case 3: {
        this.avatarUrl = $r('app.media.avatar_3');
        break;
      }
      default : {
        this.avatarUrl = $r('app.media.ic_user_portrait');
        break;
      }
    }
  }
}

//导出User实例（本机用户）
let user: User = new User();

export default user as User