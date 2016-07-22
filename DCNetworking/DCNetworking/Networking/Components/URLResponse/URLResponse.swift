//
//  URLResponse.swift
//  OneAPP
//
//  Created by DcBunny on 16/7/18.
//  Copyright © 2016年 onenet. All rights reserved.
//

import Foundation

class URLResponse {
    
    let status: URLResponseStatus
    let contentString: String
    let requestId: Int
    let request: NSURLRequest
    let responseData: NSData
    
    init(withResponseString responseString: String, requestId: Int, request: NSURLRequest, responseData: NSData, status: URLResponseStatus) {
        self.contentString = responseString
        self.status = status
        self.requestId = requestId
        self.responseData = responseData
        self.request = request
    }
    
    init(withResponseString responseString: String, requestId: Int, request: NSURLRequest, responseData: NSData, error: NSError) {
        self.contentString = responseString
        self.requestId = requestId
        self.responseData = responseData
        self.request = request
        
        if error.code == NSURLErrorTimedOut {
            self.status = URLResponseStatus.ErrorTimeout
        } else {
            self.status = URLResponseStatus.ErrorNoNetwork
        }
    }
}
