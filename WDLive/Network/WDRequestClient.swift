//
//  WDRequestClient.swift
//  WDLive
//
//  Created by scott on 2025/4/1.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
 * 通过Client，把发起网络请求的代码从Requets中抽离出来
 * Client抽象了发送网络请求，不同的业务模块可能有不同的处理方式。
 * 比如json数据或者grpc数据，比如使用不同的底层库Alamofire或者AFN
 */
protocol Client {
    func send<T: WDRequestable>(_ request: T, completion: @escaping (Result<T.Response?, Error>) -> Void)
    var host: String { get }
}

struct WDRequestClient: Client {
    // 主机地址，也可以根据需要在WDRequestClient()实例时传入
    var host: String = "https://neteasecloudmusicapi.vercel.app"
    // 发起调用
    public func send<T: WDRequestable>(_ request: T, completion: @escaping (Result<T.Response?, Error>) -> Void) {
        let url = host + request.path
        let method = HTTPMethod(rawValue: request.method.rawValue)
        let parameters = request.parameters
        AF.request(url, method: method, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let json = JSON(value)
                    if let code = json["code"].int, code != 200 {
                        throw AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: code))
                    }
                    guard let result = json["result"].dictionaryObject else {
                        throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                    }
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(T.Response.self, from: JSONSerialization.data(withJSONObject: result))
                    completion(.success(model))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
