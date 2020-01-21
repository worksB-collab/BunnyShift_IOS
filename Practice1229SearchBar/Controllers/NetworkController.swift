//
//  NetworkController.swift
//  Practice1229SearchBar
//
//  Created by cm0521 on 2020/1/2.
//  Copyright © 2020 cm0521. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class NetWorkController: NSObject {
    // 伺服器網址
    static let rootUrl : String = "http://35.226.116.19:3000/api"
    
    
    // 單例
    static let sharedInstance = NetWorkController()
    
    var alamofireManager:Alamofire.SessionManager!
    
    fileprivate override init() {
        // 初始化
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 20
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func post(api : String, params : Dictionary<String, Any>, callBack:((JSON) -> ())?){
        alamofireManager.request(NetWorkController.rootUrl + api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:])
            .validate(statusCode: 200 ..< 500).responseJSON
            {
                (response) in
                if response.result.isSuccess{
                    let jsonData = try! JSON(data: response.data!)
//                    let status = jsonData.dictionary!["Status Code"]?.int
//
//                    if status == 200 {
//                        callBack?(jsonData)
//                        print("請求成功 \(String(describing: response.result.value))")
//                    }else{
//                        print("請求失敗 callBack 後端寫錯那種: \(response.debugDescription)")
//                    }
                    
                    print("請求成功 \(String(describing: response.result.value))")
                    callBack?(jsonData)
                    
                }else{
                    print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                }
            }
    }
    
    func postT(api : String, params : Dictionary<String, Any>, callBack:((JSON) -> ())?){
            alamofireManager.request(NetWorkController.rootUrl + api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["authorization" : Global.token!])
                .validate(statusCode: 200 ..< 500).responseJSON
                {
                    (response) in
                    if response.result.isSuccess{
                        let jsonData = try! JSON(data: response.data!)
    //                    let status = jsonData.dictionary!["Status Code"]?.int
    //
    //                    if status == 200 {
    //                        callBack?(jsonData)
    //                        print("請求成功 \(String(describing: response.result.value))")
    //                    }else{
    //                        print("請求失敗 callBack 後端寫錯那種: \(response.debugDescription)")
    //                    }
                        
                        print("請求成功 \(String(describing: response.result.value))")
                        callBack?(jsonData)
                        
                    }else{
                        print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                    }
                }
        }

    
    func get(api : String, callBack:((JSON) -> ())?){
            alamofireManager.request(NetWorkController.rootUrl + api, encoding: JSONEncoding.default, headers: [ "authorization" : Global.token! ]).validate(statusCode: 200 ..< 500).responseJSON
                {
                    (response) in
                    if response.result.isSuccess{
                        let jsonData = try! JSON(data: response.data!)
    //                    let status = jsonData.dictionary!["Status Code"]?.int
    //
    //                    if status == 200 {
    //                        callBack?(jsonData)
    //                        print("請求成功 \(String(describing: response.result.value))")
    //                    }else{
    //                        print("請求失敗 callBack 後端寫錯那種: \(response.debugDescription)")
    //                    }
                        
                        print("請求成功 \(jsonData)")
                        callBack?(jsonData)
                        
                    }else{
                        print("請求失敗 callBack onFailure那種: \(response.debugDescription)")
                    }
                }
        }
    
    
} 
