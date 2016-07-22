//
//  AppContext.swift
//  OneAPP
//
//  Created by DcBunny on 16/7/21.
//  Copyright © 2016年 onenet. All rights reserved.
//

import Foundation
import Alamofire

class AppContext {
    
    //MARK: - life cycle
    static let sharedInstance = AppContext()
    
    private let networkReachabilityManager: NetworkReachabilityManager
    
    private init() {
        let host = ServiceFactory.sharedInstance.serviceWithId(ServiceNameList.oneapp).apiBaseUrl
        networkReachabilityManager = NetworkReachabilityManager(host: host)!
    }
    
    func isReachable() -> Bool {
        return networkReachabilityManager.isReachable
    }
}
