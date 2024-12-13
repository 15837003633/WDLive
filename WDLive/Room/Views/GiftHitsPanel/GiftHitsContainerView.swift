//
//  GiftHitsContainerView.swift
//  WDLive
//
//  Created by scott on 2024/12/10.
//

import UIKit

class GiftHitsContainerView: UIView, NibLoadEnable {

    var cellCount = 2
    var cellList: [GiftHitsCellView] = [GiftHitsCellView]()
    var giftCacheQueue: [GiftModel] = [GiftModel]()

    let cellWidth: CGFloat = 300
    let cellHeight: CGFloat = 40
    let cellMargin: CGFloat = 20

    override func awakeFromNib() {
        super.awakeFromNib()

        for i in 0..<cellCount {
            let x = -cellWidth
            let y = CGFloat(i) * (cellHeight + cellMargin)
            let cell = GiftHitsCellView.loadNibView()
            cell.delegate = self
            cell.frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            cell.alpha = 0
            addSubview(cell)
            cellList.append(cell)
        }
    }

    public func show(_ gift: GiftModel) {
        // 1. 检查礼物是否已经存在正在显示的相同礼物的cell，存在就更新cell
        if let playingCell = checkHasSameGiftInCellList(gift) {
            playingCell.addOnceSameHitsToCache(gitfCount: gift.sendCount)
            return
        }

        // 2. 获取一个闲置的cell来显示礼物
        if let idleCell = checkHasIdleCell() {
            idleCell.show(gift: gift)
            return
        }

        // 3. 加入到缓存
        giftCacheQueue.append(gift)
    }

    private func checkHasSameGiftInCellList(_ gift: GiftModel) -> GiftHitsCellView? {
        for cell in cellList {
            if let cellGiftModel = cell.giftModel, cellGiftModel.isEqual(gift), cell.state != .dismissAnimating {
                return cell
            }
        }
        return nil
    }

    private func checkHasIdleCell() -> GiftHitsCellView? {
        for cell in cellList where cell.state == .idle {
            return cell
        }
        return nil
    }

}

extension GiftHitsContainerView: GiftHitsCellViewDelegate {
    func dismissedCell(_ cell: GiftHitsCellView) {
        guard !giftCacheQueue.isEmpty else { return }

        // 1.取出队列第一个开始播放
        let nextGift = giftCacheQueue.removeFirst()
        cell.show(gift: nextGift)

        // 2.检查缓存里和上面相同的礼物，加入到cell的连击缓存
        let sameCondition: (GiftModel) -> Bool = {$0.isEqual(nextGift)}
        let sameGift = giftCacheQueue.filter(sameCondition)
        giftCacheQueue.removeAll(where: sameCondition)
        sameGift.forEach {
            cell.addOnceSameHitsToCache(gitfCount: $0.sendCount)
        }
    }
}
