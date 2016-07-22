//
//  OneAPPService.swift
//  OneAPP
//
//  Created by DcBunny on 16/7/19.
//  Copyright © 2016年 onenet. All rights reserved.
//

import Foundation

class OneAPPService: Service, ServiceProtocol {
    
    //MARK: - ServiceProtocol
    func onlineApiBaseUrl() -> String {
        
        return "http://restapi.amap.com"
    }
    
    func onlineApiVersion() -> String {
        
        return "v3"
    }
    
    func onlineApiCommonPath() -> String {
        
        return "oneapp"
    }
}
