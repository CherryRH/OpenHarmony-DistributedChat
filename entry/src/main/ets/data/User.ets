
/*
 * 类：用户
 * */
class User {
  private userID: string;
  private name: string;
  private avatarUrl: Resource;

  constructor(userID?: string, userName?: string, avatarUrl?: Resource) {
    this.userID = userID ?? 'User@unknown.com';
    this.name = userName ?? 'User';
    this.avatarUrl = avatarUrl ?? $r('app.media.ic_user_portrait');
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

  public setName(username: string): void {
    this.name = username;
  }

  public setID(userID: string) {
    this.userID = userID;
  }

  public setAvatarUrl(avatarUrl: Resource): void {
    this.avatarUrl = avatarUrl;
  }

}

export default User