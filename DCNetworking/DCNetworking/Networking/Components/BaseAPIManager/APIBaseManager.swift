//
//  APIBaseManager.swift
//  OneAPP
//
//  Created by 李宏博 on 16/6/22.
//  Copyright © 2016年 onenet. All rights reserved.
//

import Foundation

class APIBaseManager {
    
    // 由负责调用API接口的业务Controller实现
    weak var delegate: APIManagerCallBackDelegate?
    weak var paramSource: APIManagerParamSource?
    
    // 由SubAPIManager来实现
    weak var validator: APIManagerValidator?
    private weak var child: APIManager?
    
    var errorMessage: String?
    var errorType: APIManagerErrorType
    var response: URLResponse?
    
    var isLoading: Bool
    
    private var fetchedRawData: NSData?
    private var _requestIdList: [Int]?
    
    init() {
        delegate = nil
        paramSource = nil
        validator = nil
        
        isLoading = false
        
        errorMessage = nil
        errorType = .Default
        
        if let aChild = self as? APIManager {
            child = aChild
        } else {
            //TODO: 抛出异常
            return
        }
    }
    
    deinit {
        cancelAllRequests()
        _requestIdList = nil
        
    }
    
    //MARK: - public methods
    func cancelAllRequests() {
        ApiProxy.sharedInstance.cancelRequestWithRequestIdList(requestIdList)
        requestIdList.removeAll()
    }
    
    func cancelRequestWithRequestId(requestId: Int) {
        if removeRequestIdWithRequestId(requestId) {
            ApiProxy.sharedInstance.cancelRequestWithRequestId(requestId)
        }
    }
    
    func fetchDataWithReformer(reformer: APIManagerDataReformer?) -> AnyObject {
        var resultData: AnyObject
        
        if let myReformer = reformer {
            resultData = myReformer.manager(self, reformData: fetchedRawData!)
        } else {
            resultData = fetchedRawData!
        }
        
        return resultData
    }
    
    //MARK: - calling api
    func loadData() -> Int {
        let params = paramSource?.paramsForApi(self)
        let requestId = loadDataWithParams(params!)
        
        return requestId
    }
    
    private func loadDataWithParams(params: ParamData) -> Int {
        var requestId = 0
        if validator!.manager(self, isCorrectWithParamsData: params) {
            if isReachable {
                isLoading = true
                switch child!.requestType() {
                case .Get:
                    requestId = callAPI(.Get, withParam: params)
                    
                case .Post:
                    requestId = callAPI(.Post, withParam: params)
                }
                
                return requestId
            } else {
                failedOnCallingApi(nil, withErrorType: .NoNetWork)
                
                return requestId
            }
        } else {
            failedOnCallingApi(nil, withErrorType: .ParamsError)
            
            return requestId
        }
    }
    
    //MARK: - api callbacks
    private func successedOnCallingApi(response: URLResponse) {
        isLoading = false
        self.response = response
        fetchedRawData = response.responseData
        
        removeRequestIdWithRequestId(response.requestId)
        if validator!.manager(self, isCorrectWithCallBackData: response.responseData) {
            delegate!.managerCallAPIDidSuccess(self)
        } else {
            failedOnCallingApi(response, withErrorType: APIManagerErrorType.NoContent)
        }
    }
    
    //TODO: 处理多种错误类型
    private func failedOnCallingApi(response: URLResponse?, withErrorType errorType: APIManagerErrorType) {
        isLoading = false
        self.response = response
        self.errorType = errorType
        if let hasResponse = response {
            removeRequestIdWithRequestId(hasResponse.requestId)
        }
        delegate?.managerCallAPIDidFailed(self)
    }
    
    //MARK: - private methods
    private func removeRequestIdWithRequestId(requestId: Int) -> Bool {
        var isRemoved = false
        
        var indexToRemove: Int?
        for index in 0 ..< requestIdList.count  {
            if requestIdList[index] == requestId {
                indexToRemove = index
            }
        }
        if let rmIndex = indexToRemove {
            requestIdList.removeAtIndex(rmIndex)
            isRemoved = true
        }
        
        return isRemoved
    }
    
    private func callAPI(requeseType: APIManagerRequestType, withParam param: ParamData) -> Int {
        var requestId = 0
        switch requeseType {
        case .Get:
            requestId = ApiProxy.sharedInstance.callGETWithParams(
                param,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    self?.successedOnCallingApi(response)
                },
                fail: { [weak self]
                    response in
                    self?.failedOnCallingApi(response, withErrorType: .Default)
                })
            
        case .Post:
            requestId = ApiProxy.sharedInstance.callPOSTWithParams(
                param,
                serviceId: child!.serviceType(),
                methodName: child!.methodName(),
                success: { [weak self]
                    response in
                    self?.successedOnCallingApi(response)
                },
                fail: { [weak self]
                    response in
                    self?.failedOnCallingApi(response, withErrorType: .Default)
                })
        }
        requestIdList.append(requestId)
        
        return requestId
    }
    
    //MARK: - getters and setters
    var requestIdList: [Int] {
        get {
            if _requestIdList == nil {
                _requestIdList = [Int]()
            }
            
            return _requestIdList!
        }
        
        set {}
    }
    
    var isReachable: Bool {
        get {
            let isReachability = AppContext.sharedInstance.isReachable()
            if !isReachability {
                errorType = APIManagerErrorType.NoNetWork
            }
            return isReachability
        }
    }
}
