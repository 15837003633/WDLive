//
//  RoomRequest.swift
//  WDLive
//
//  Created by scott on 2024/12/7.
//

import Foundation

struct MusicRequest: WDRequestable {
    
    let keywords: String
    
    typealias Response = SongList

    var path: String {
        "/search"
    }

    var method: WDRequestMethod {
        .GET
    }

    var headers: [String: Any]? {
        nil
    }

    var parameters: [String: Any]? {
        [
            "keywords": keywords
        ]
    }
}

struct SongInfoModel: Decodable {
    var id: Int
    var name: String
    var duration: Int
}

struct SongList: Decodable {
    var hasMore: Bool
    var songCount: Int
    var songs: [SongInfoModel]
}
