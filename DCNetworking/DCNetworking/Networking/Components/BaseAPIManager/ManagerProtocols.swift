//
//  ManagerProtocols.swift
//  OneAPP
//
//  Created by DcBunny on 16/7/18.
//  Copyright © 2016年 onenet. All rights reserved.
//

import Foundation

//MARK: - APIManagerApiCallBackDelegate

/*************************************************************************************************/
/*                               APIManagerApiCallBackDelegate                                   */
/*************************************************************************************************/

// API 回调
protocol APIManagerCallBackDelegate: class {
    
    func managerCallAPIDidSuccess(manager: APIBaseManager)
    func managerCallAPIDidFailed(manager: APIBaseManager)
}


//MARK: - APIManagerCallbackDataReformer

/*************************************************************************************************/
/*                               APIManagerCallbackDataReformer                                  */
/*************************************************************************************************/
protocol APIManagerDataReformer {
    
    func manager(manager: APIBaseManager, reformData data: NSData) -> AnyObject
}


//MARK: - APIManagerValidator

/*************************************************************************************************/
/*                                     APIManagerValidator                                       */
/*************************************************************************************************/

//验证器，用于验证调用API的参数或者API的返回是否正确
protocol APIManagerValidator: class {
    
    func manager(manager: APIBaseManager, isCorrectWithParamsData data: ParamData) -> Bool
    func manager(manager: APIBaseManager, isCorrectWithCallBackData data: NSData) -> Bool
}


//MARK: - APIManagerParamSourceDelegate

/*************************************************************************************************/
/*                                APIManagerParamSourceDelegate                                  */
/*************************************************************************************************/

//让manager能够获取调用API所需要的数据
protocol APIManagerParamSource: class {
    
    func paramsForApi(manager: APIBaseManager) -> ParamData
}

//MARK: - 常量／状态／类型 枚举类型

/*************************************************************************************************/
/*                                      常量／状态／类型 枚举类型                                         */
/*************************************************************************************************/

let APIBaseManagerRequestID = "APIBaseManagerRequestID"

enum APIManagerRequestType: Int {
    
    case Get = 0
    case Post
}

enum APIManagerErrorType: Int {
    
    case Default = 0        //没有产生过API请求，这个是manager的默认状态。
    case Success            //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    case NoContent          //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    case ParamsError        //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    case Timeout            //请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    case NoNetWork          //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
}

typealias ParamData = [String: AnyObject]


//MARK: - APIManager

/*************************************************************************************************/
/*                                         APIManager                                            */
/*************************************************************************************************/

// APIBaseManager的派生类必须符合这些protocal
protocol APIManager: class {
    
    func methodName() -> String
    func serviceType() -> String
    func requestType() -> APIManagerRequestType
}
