//
//  NibEnableProtocol.swift
//  WDLive
//
//  Created by scott on 2024/12/10.
//

import UIKit

protocol NibLoadEnable {
    static func loadNibView() -> Self
}

extension NibLoadEnable where Self: UIView {
    static func loadNibView() -> Self {
        let view = Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
        return view
    }
}
