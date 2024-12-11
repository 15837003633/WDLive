//
//  GiftHitsCellView.swift
//  WDLive
//
//  Created by scott on 2024/12/10.
//

import UIKit

protocol GiftHitsCellViewDelegate: AnyObject {
    func dismissedCell(_ cell: GiftHitsCellView)
}

class GiftHitsCellView: UIView, NibLoadEnable {
    
    enum State {
        case idle, displayAnimating, willDismiss, dismissAnimating
    }
    
    struct Constraint {
        static let displayAnimationDuration: CGFloat = 0.5
        static let dismissAnimationDuration: CGFloat = 0.5
        static let dispalyDuration: CGFloat = 2
    }

    @IBOutlet weak var digitLabel: GiftDigitLabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    //记录所有连击的累计礼物数量
    private var totalCount: Int = 0
    //定义一个数组，用于缓存多个相同礼物的连击。
    private var hitsCacheQueue: [Int] = []
    
    //记录当前cell的状态
    public var state: State = .idle
    public weak var delegate: GiftHitsCellViewDelegate?

    
    var giftModel: GiftModel? {
        didSet {
            guard let newValue = giftModel else { return }
            self.giftImageView.image = UIImage(named: newValue.pic)
            self.contentLabel.text = "\(newValue.username) 送出 \(newValue.name)"
            self.digitLabel.text = "x\(newValue.sendCount)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
}


//cell动画过程
extension GiftHitsCellView {
    //1.弹出cell
    func performCellDisplayAnimation(){
        self.state = .displayAnimating
        UIView.animate(withDuration: Constraint.displayAnimationDuration) {
            self.frame.origin.x = 0
            self.alpha = 1
        } completion: { finish in
            self.performDigitLabelAnimation(self.giftModel?.sendCount ?? -1)
        }
    }
    
    //2.礼物数量跳动
    func performDigitLabelAnimation(_ giftCount: Int){
        totalCount += giftCount
        self.digitLabel.text = "x\(totalCount)"
        self.digitLabel.performAnimation {
            if self.hitsCacheQueue.count > 0 {
                let nextGiftCount = self.hitsCacheQueue.removeFirst()
                self.performDigitLabelAnimation(nextGiftCount)
            }else {
                self.state = .willDismiss
                self.perform(#selector(self.performCellDismissAnimation), with: nil, afterDelay: Constraint.dispalyDuration)
            }
        }
    }
    
    //3.cell消失
    @objc
    func performCellDismissAnimation(){
        self.state = .dismissAnimating
        UIView.animate(withDuration: Constraint.dismissAnimationDuration) {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0
        } completion: { finish in
            self.frame.origin.x = -self.frame.width
            self.giftModel = nil
            self.state = .idle
            self.totalCount = 0
            self.hitsCacheQueue.removeAll()
            self.digitLabel.text = ""
            self.giftImageView.image = nil
            self.contentLabel.text = ""
            
            //通知代理动画已完成
            self.delegate?.dismissedCell(self)
        }
    }
}

//对外提供的方法
extension GiftHitsCellView {
    public func show(gift: GiftModel){
        self.giftModel = gift
        performCellDisplayAnimation()
    }
    
    public func addOnceSameHitsToCache(gitfCount: Int){
        if self.state == .willDismiss {
            self.state = .displayAnimating
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.performCellDismissAnimation), object: nil)
            performDigitLabelAnimation(gitfCount)
        }else{
            hitsCacheQueue.append(gitfCount)
        }
    }
}
