//
//  RoomRequest.swift
//  WDLive
//
//  Created by scott on 2024/12/7.
//

import Foundation

struct MusicRequest: WDRequestable {

    typealias Response = SongList

    var path: String {
        "https://neteasecloudmusicapi.vercel.app/search"
    }

    var method: WDRequestMethod {
        .GET
    }

    var headers: [String: Any]? {
        nil
    }

    var parameters: [String: Any]? {
        [
            "keywords": "海阔天空"
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
