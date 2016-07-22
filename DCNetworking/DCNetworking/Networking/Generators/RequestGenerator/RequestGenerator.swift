//
//  RequestGenerator.swift
//  OneAPP
//
//  Created by DcBunny on 16/7/19.
//  Copyright © 2016年 onenet. All rights reserved.
//

import Foundation
import Alamofire

class RequestGenerator {
    
    //MARK: - life cycle
    static let sharedInstance = RequestGenerator()
    
    private init() {}
    
    //MARK: - public func
    func generateGETRequestWithServiceId(serviceId: String, requestParams: ParamData, methodName: String) -> NSURLRequest {
        let service = ServiceFactory.sharedInstance.serviceWithId(serviceId)
        var urlString: String
        if service.apiVersion.characters.count != 0 {
            urlString = service.apiBaseUrl + "/" + service.apiVersion + "/" + service.apiCommonPath + "/" + methodName
        } else {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + methodName
        }
        
        let URL = NSURL(string: urlString)!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: requestParams)
        
        return request
    }
    
    func generatePOSTRequestWithServiceId(serviceId: String, requestParams: ParamData, methodName: String) -> NSURLRequest {
        let service = ServiceFactory.sharedInstance.serviceWithId(serviceId)
        var urlString: String
        if service.apiVersion.characters.count != 0 {
            urlString = service.apiBaseUrl + "/" + service.apiVersion + "/" + service.apiCommonPath + "/" + methodName
        } else {
            urlString = service.apiBaseUrl + "/" + service.apiCommonPath + "/" + methodName
        }
        
        let URL = NSURL(string: urlString)!
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: requestParams)
        
        return request
    }
}
