//
//  ViewController.swift
//  DCNetworking
//
//  Created by DcBunny on 16/7/22.
//  Copyright © 2016年 DcBunny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var resultLabel: UILabel!
    
    let testAPIManager = TestAPIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPageSubViews()
        setDelegateAndDataSource()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        testAPIManager.loadData()
    }
    
    func loadPageSubViews() {
        resultLabel = {
            let label = UILabel(frame: CGRect(x: 150, y: 300, width: 100, height: 40))
            label.text = "loading API..."
            view.addSubview(label)
            return label
        }()
    }
    
    func setDelegateAndDataSource() {
        testAPIManager.paramSource = self
        testAPIManager.delegate = self
    }
}

extension ViewController: APIManagerParamSource {
    
    func paramsForApi(manager: APIBaseManager) -> ParamData {
        let params = [
            "key": "384ecc4559ffc3b9ed1f81076c5f8424",
            "location": "121.454290,31.228000",
            "output": "json"
        ]
        
        return params
    }
}

extension ViewController: APIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: APIBaseManager) {
        if manager === testAPIManager {
            resultLabel.text = "success"
            let data = manager.fetchDataWithReformer(nil)
            print(data)
        }
    }
    
    func managerCallAPIDidFailed(manager: APIBaseManager) {
        if manager === testAPIManager {
            resultLabel.text = "fail"
            print(manager.errorType)
            print(manager.response?.contentString)
        }
    }
}
