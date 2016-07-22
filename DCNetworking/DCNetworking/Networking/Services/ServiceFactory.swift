//
//  ServiceFactory.swift
//  OneAPP
//
//  Created by DcBunny on 16/7/19.
//  Copyright © 2016年 onenet. All rights reserved.
//

import Foundation

struct ServiceNameList {
    
    static let oneapp = "ServiceOneAPP"
}

class ServiceFactory {
    
    //MARK: - life cycle
    static let sharedInstance = ServiceFactory()
    
    var serviceStorage: [String: Service]
    
    private init() {
        serviceStorage = [String: Service]()
    }
    
    //MARK: - public methods
    func serviceWithId(id: String) -> Service {
        if serviceStorage[id] == nil {
            if let newService = newServiceWithId(id) {
                 serviceStorage[id] = newService
            }
        }
        
        return serviceStorage[id]!
    }
    
    //MARK: - private methods
    private func newServiceWithId(id: String) -> Service? {
        if id == ServiceNameList.oneapp {
            return OneAPPService()
        }
        
        return nil
    }
}
