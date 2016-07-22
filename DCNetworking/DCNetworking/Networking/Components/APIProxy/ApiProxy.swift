//
//  ApiProxy.swift
//  OneAPP
//
//  Created by DcBunny on 16/7/18.
//  Copyright © 2016年 onenet. All rights reserved.
//

import Foundation
import Alamofire

typealias ApiCallback = (URLResponse) -> ()

class ApiProxy {
    
    var dispathcTable: [Int: NSURLSessionTask]
    
    //MARK: - life cycle
    static let sharedInstance = ApiProxy()
    
    private init() {
        dispathcTable = [Int: NSURLSessionTask]()
    }
    
    //MARK: - public methods
    func callGETWithParams(params: ParamData, serviceId: String, methodName: String, success: ApiCallback, fail: ApiCallback) -> Int {
        let request = RequestGenerator.sharedInstance.generateGETRequestWithServiceId(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request, success: success, fail: fail)
        
        return requestId
    }
    
    func callPOSTWithParams(params: ParamData, serviceId: String, methodName: String, success: ApiCallback, fail: ApiCallback) -> Int {
        let request = RequestGenerator.sharedInstance.generatePOSTRequestWithServiceId(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request, success: success, fail: fail)
        
        return requestId
    }
    
    func cancelRequestWithRequestId(requestId: Int) {
        let requestOperation = dispathcTable[requestId]
        requestOperation?.cancel()
        dispathcTable.removeValueForKey(requestId)
    }
    
    func cancelRequestWithRequestIdList(requestIdList: [Int]) {
        for requestId in requestIdList {
            cancelRequestWithRequestId(requestId)
        }
    }
    
    //MARK: - private methods
    private func callApiWithRequest(request: NSURLRequest, success: ApiCallback, fail: ApiCallback) -> Int {
        var task: NSURLSessionTask? = nil
        task = Alamofire.request(request).responseJSON { response in
            let id = task!.taskIdentifier
            self.dispathcTable.removeValueForKey(id)
            let responseData = response.data
            let responseString = String(data: responseData!, encoding: NSUTF8StringEncoding)
            
            switch response.result {
            case .Success:
                let urlResponse = URLResponse(withResponseString: responseString!, requestId: id, request: request, responseData: responseData!, status: URLResponseStatus.Success)
                success(urlResponse)
                
            case .Failure(let error):
                let urlResponse = URLResponse(withResponseString: responseString!, requestId: id, request: request, responseData: responseData!, error: error)
                fail(urlResponse)
            }
        }.task
        
        let requestId = task!.taskIdentifier
        
        return requestId
    }
}
