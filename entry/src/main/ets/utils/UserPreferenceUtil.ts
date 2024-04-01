import preferences from '@ohos.data.preferences'

/*
 * 用户首选项工具类
 * */

class UserPreferenceUtil {
  //日志Tag
  logTag: string = 'TestTag'
  //首选项实例，用键值对保存多个不同的首选项
  prefMap: Map<string, preferences.Preferences> = new Map()
  //加载首选项实例（异步）
  loadPreference_async(context, name: string) {
    preferences.getPreferences(context, name)
      .then(pref => {
        this.prefMap.set(name, pref)
        console.log(this.logTag, 'UserPreference ' + name + ' 加载成功')
        return true;
      })
      .catch(Error => {
        console.log(this.logTag, 'UserPreference ' + name + ' 加载失败', JSON.stringify(Error))
        return false;
      })
  }
  //加载首选项实例（同步）
  async loadPreference(context, name: string) {
    try {
      let pref = await preferences.getPreferences(context, name)
      this.prefMap.set(name, pref)
      console.log(this.logTag, 'UserPreference ' + name + ' 加载成功')
      return true;
    }
    catch (Error) {
      console.log(this.logTag, 'UserPreference ' + name + ' 加载失败', JSON.stringify(Error))
      return false;
    }
  }
  //保存键值对（同步）
  async putPereferenceValue(name: string, key: string, value: preferences.ValueType) {
    if(!this.prefMap.has(name)) {
      console.log(this.logTag, 'UserPreference ' + name + ' 未加载')
      return false;
    }
    try {
      let pref = this.prefMap.get(name)
      await pref.put(key, value)
      await pref.flush()
      console.log(this.logTag, 'UserPreference ' + name + ' 保存 ' + key + ' = ' + value + ' 成功')
      return true;
    }
    catch (Error) {
      console.log(this.logTag, 'UserPreference ' + name + ' 保存 ' + key + ' = ' + value + ' 失败', JSON.stringify(Error))
      return false;
    }
  }
  //读取键值对（同步）
  async getPereferenceValue(name: string, key: string, defaultValue: preferences.ValueType) {
    if(!this.prefMap.has(name)) {
      console.log(this.logTag, 'UserPreference ' + name + ' 未加载')
      return null;
    }
    try {
      let pref = this.prefMap.get(name)
      let value = await pref.get(key, defaultValue)
      console.log(this.logTag, 'UserPreference ' + name + ' 读取 ' + key + ' = ' + value + ' 成功')
      return value
    }
    catch (Error) {
      console.log(this.logTag, 'UserPreference ' + name + ' 读取 ' + key + ' 的值失败', JSON.stringify(Error))
      return null;
    }
  }
}

const preferenceUtil = new UserPreferenceUtil()

export default preferenceUtil as UserPreferenceUtil