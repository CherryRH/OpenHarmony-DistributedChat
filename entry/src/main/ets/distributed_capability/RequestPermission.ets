// This File was used to ask for the permissions
// (current it has 1 permission:DISTRIBUTED_DATASYNC)
import abilityAccessCtrl , {Permissions}from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';
import common from '@ohos.app.ability.common';
let atManager = abilityAccessCtrl.createAtManager() ;
export async function getAccessTokenID(permission:Array<Permissions>)
{
  let tokenID:number ;
  // save the status of each permissions
  let grantStatus:Array<abilityAccessCtrl.GrantStatus> = [] ;
  // try {
    let bundleInfo : bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION) ;
    let appInfo : bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenID = appInfo.accessTokenId ;
  // }
  // catch(err)
  // {
  //   console.error(`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`);
  // }
  const len:number = permission.length ;
  for(let i = 0 ; i < len ; i++)
  {
    try{
      grantStatus.push(await atManager.checkAccessToken(tokenID,permission[i])) ;
    }
    catch(err)
    {
      console.error(`checkAccessToken failed, code is ${err.code}, message is ${err.message}`);
    }
  }
  return grantStatus ;
}
export async function checkPermission(context: common.UIAbilityContext , permissions:Array<Permissions>)
{
  let grantStatus:Array<abilityAccessCtrl.GrantStatus> = await getAccessTokenID(permissions) ;
  const len = permissions.length ;
  for(let i = 0 ; i < len ; i++)
  {
    // permission has granted
    if(grantStatus[i]==abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    {
      console.info(`${ permissions[i].toString() } has granted`) ;
    }
    else
    {
      console.info(`${ permissions[i].toString() } hasn't granted , request now`) ;
      requestPermission(context,permissions) ;
    }
  }

}
export async function requestPermission(context: common.UIAbilityContext , permissions : Array<Permissions>)
{
  // it will return a promise , the parameter "data" is a "PermissionRequestResult"
  atManager.requestPermissionsFromUser(context , permissions).then((data)=>
  {
    let permissionStatus : Array<number> = data.authResults ; // 0 : granted ; -1 : reject
    let length : number = permissionStatus.length ;
    // traverse the permission's status to check if we get the permission we need .
    for(let i = 0 ; i < length ; i++)
    {
      if(permissionStatus[i] === 0)
      {
        console.info(`REQUEST ${ permissions[i].toString() } Success`) ;
      }
      else {
        console.info(`REQUEST ${ permissions[i].toString() } Rejected!`)
      }
    }
  })
}