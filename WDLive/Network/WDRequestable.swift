//
//  WDRequestable.swift
//  WDLive
//
//  Created by scott on 2024/12/7.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol WDRequestable {
    var path: String { get }
    var method: WDRequestMethod { get }
    var headers: [String: Any]? { get }
    var parameters: [String: Any]? { get }

    associatedtype Response: Decodable
}

extension WDRequestable {
    var method: WDRequestMethod {
        .GET
    }

    func request(_ completion: @escaping (Response?) -> Void) {
        AF.request(path, method: HTTPMethod(rawValue: method.rawValue), parameters: parameters).responseJSON { response in
            let json = JSON(response.value!)
            guard let code = json["code"].int, code == 200 else {
                print("reuqest error code:", response )
                return
            }
            guard let result = json["result"].dictionaryObject else { return }
            let decoder = JSONDecoder()
            let model = try? decoder.decode(Response.self, from: JSONSerialization.data(withJSONObject: result))
            completion(model)
        }
    }
    func test1<T: UIView>() -> T {
        return T()
    }
}
