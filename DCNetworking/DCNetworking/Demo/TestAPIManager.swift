//
//  TestAPIManager.swift
//  OneAPP
//
//  Created by DcBunny on 16/7/21.
//  Copyright © 2016年 onenet. All rights reserved.
//

import Foundation

class TestAPIManager: APIBaseManager {
    
    //MARK: - life cycle
    override init() {
        super.init()
        
        self.validator = self
    }
}

extension TestAPIManager: APIManager {
    
    //MARK: - APIManager
    func methodName() -> String {
        return "geocode/regeo"
    }
    
    func serviceType() -> String {
        return ServiceNameList.oneapp
    }
    
    func requestType() -> APIManagerRequestType {
        return APIManagerRequestType.Get
    }
}

extension TestAPIManager: APIManagerValidator {
    
    //MARK: - APIManagerValidator
    func manager(manager: APIBaseManager, isCorrectWithParamsData data: ParamData) -> Bool {
        return true
    }
    
    func manager(manager: APIBaseManager, isCorrectWithCallBackData data: NSData) -> Bool {
        return true
    }
}
