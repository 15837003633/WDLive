//
//  WDPagerContentView.swift
//  WDLive
//
//  Created by scott on 2024/12/6.
//

import UIKit

let kContentCellID = "UICollectionViewCell"

protocol WDPagerContentViewDelegate: AnyObject{
    func pagerContentView(_ pagerContenView: WDPagerContentView, didTo targetIndex: Int)
    func pagerContentView(_ pagerContenView: WDPagerContentView, willTo targetIndex: Int, progress: CGFloat)
}

class WDPagerContentView: UIView {

    public weak var delegate: WDPagerContentViewDelegate?
    private let childVCs: [UIViewController]
    private let parentVC: UIViewController
    private let style: WDPagerStyle
    private var beginDraggingOffsetX: CGFloat = 0 //记录开始拖拽时的collectionView的位置
    private var forbidScroll: Bool = false //控制点击标题时，禁用滚动的过渡progress效果
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController, style: WDPagerStyle) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = bounds.size
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cview = UICollectionView(frame: bounds, collectionViewLayout: layout)
        cview.scrollsToTop = false
        cview.isPagingEnabled = true
        cview.bounces = false
        cview.dataSource = self
        cview.delegate = self
        cview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        return cview
    }()
    
}

extension WDPagerContentView {
    func setupUI(){
        addSubview(collectionView)
        for subVC in childVCs {
            parentVC.addChild(subVC)
        }
    }
    
}

extension WDPagerContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let subView = childVCs[indexPath.row].view!
        subView.frame = cell.contentView.bounds
        cell.contentView.addSubview(subView)
        return cell
    }
}

extension WDPagerContentView: UICollectionViewDelegate, UIScrollViewDelegate{
    // MARK: - 处理滚动结束逻辑
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndScroll()
        scrollView.isScrollEnabled = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            didEndScroll()
        }else{
            //禁用拖拽滚动，防止滚动过快，解决小问题：上一次滚动还没结束，就开始快速拖拽下一次，导致beginDraggingOffsetX不是一个页面整数倍的值，导致ui出现bug
            scrollView.isScrollEnabled = false
        }
    }
    
    private func didEndScroll(){
        let offsetX = collectionView.contentOffset.x
        let currentIndex = Int(offsetX/bounds.width)
//        print("当前滚动索引\(currentIndex)")
        delegate?.pagerContentView(self, didTo: currentIndex)
        
    }
    
    // MARK: - 处理滚动中的渐变逻辑
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        forbidScroll = false
        beginDraggingOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !forbidScroll else {
            return
        }
        var targetIndex = Int(beginDraggingOffsetX/bounds.width)
        var progress = 0.0
        
        let offsetX = beginDraggingOffsetX - scrollView.contentOffset.x
        if offsetX < 0 {
            //向左滚动
            targetIndex = min(childVCs.count - 1, targetIndex + 1)
        }else if offsetX > 0{
            //向右滚动
            targetIndex = max(0, targetIndex - 1)
        }
        progress = abs(offsetX/bounds.width)
        delegate?.pagerContentView(self, willTo: targetIndex, progress: progress)
        if progress == 1 {
            delegate?.pagerContentView(self, didTo: targetIndex)
        }
    }
    
}

// 联动TitleView，TitleView点击影响ContenView滚动
extension WDPagerContentView: WDPagerTitleViewDelegate {
    func pagerTitleView(_ pagerTitleView: WDPagerTitleView, targetIndex: Int) {
        forbidScroll  = true
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .left, animated: false)
    }
}
