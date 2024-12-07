//
//  EmitterEnableProtocol.swift
//  WDLive
//
//  Created by scott on 2024/12/7.
//

import UIKit

protocol EmitterEnableProtocol{
    func startEmitter()
    func stopEmitter()
}

extension EmitterEnableProtocol where Self: UIViewController {
    func startEmitter(){
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: self.view.bounds.width - 40, y: self.view.bounds.height - 40)
        emitter.emitterShape = .point
        view.layer.addSublayer(emitter)
        
        let emitterCell = CAEmitterCell()
        emitterCell.birthRate = 3
        emitterCell.lifetime = 3
        emitterCell.lifetimeRange = 5
        emitterCell.velocity = 100
        emitterCell.velocityRange = 100
        emitterCell.scale = 0.7
        emitterCell.scaleRange = 0.3
        emitterCell.emissionLongitude = -CGFloat.pi / 2
        emitterCell.emissionRange = CGFloat.pi / 6
        emitterCell.contents = UIImage(named: "rank")?.cgImage
        
        emitter.emitterCells = [emitterCell]
    }
    
    func stopEmitter(){
        view.layer.sublayers?.filter({$0 is CAEmitterLayer}).forEach({$0.removeFromSuperlayer()})
    }
}
