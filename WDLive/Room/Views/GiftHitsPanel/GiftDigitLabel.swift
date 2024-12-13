//
//  GiftDigitLabel.swift
//  WDLive
//
//  Created by scott on 2024/12/10.
//

import UIKit

class GiftDigitLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(5)
        ctx?.setLineJoin(.round)
        textColor = .red
        UIColor.red.setStroke()
        ctx?.setTextDrawingMode(.stroke)
        super.drawText(in: rect)

        ctx?.setLineWidth(2)
        textColor = .white
        ctx?.setTextDrawingMode(.fill)
        super.drawText(in: rect)
    }

    func performAnimation(_ completetion: @escaping() -> Void) {
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            }
        } completion: {_ in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: []) {
                self.transform = .identity
            } completion: {_ in
                completetion()
            }
        }
    }

}
