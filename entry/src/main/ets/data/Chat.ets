import { User } from './User'
import Message from './Message'
/*
 * 类：聊天
 * */
class Chat {
  private iconUrl: Resource;
  private name: string;
  private ID: number = 0;

  private messageVector: Message[] = [];

  constructor(name: string, iconUrl?: Resource) {
    this.name = name;
    this.iconUrl = iconUrl ?? $r('app.media.ic_public_message');
  }

  public getIconUrl(): Resource {
    return this.iconUrl;
  }

  public getName(): string {
    return this.name;
  }

  public getID(): number {
    return this.ID;
  }

  public getNewMessage(): Message | undefined {
    if (this.messageVector.length > 0) {
      return this.messageVector[this.messageVector.length - 1];
    }
    else return undefined;
  }

  public setID(ID: number) {
    return this.ID = ID;
  }

  public sendMessage(message: Message) {
    if (!message || message.getText() === '') {
      console.log('消息不能为空');
    }
    this.messageVector.push(message);
  }
}

export default Chat