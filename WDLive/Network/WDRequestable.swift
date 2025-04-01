//
//  WDRequestable.swift
//  WDLive
//
//  Created by scott on 2024/12/7.
//

import Foundation

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
}
