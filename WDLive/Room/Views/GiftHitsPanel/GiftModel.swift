//
//  GiftModel.swift
//  WDLive
//
//  Created by scott on 2024/12/10.
//

import UIKit

class GiftModel: NSObject {
    let username: String
    let name: String
    let pic: String
    let id: Int
    let sendCount: Int

    init(username: String, name: String, pic: String, id: Int, sendCount: Int) {
        self.username = username
        self.name = name
        self.pic = pic
        self.id = id
        self.sendCount = sendCount
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? GiftModel else { return false }
        return self.id == object.id && self.username == object.username
    }

}
