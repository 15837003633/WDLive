//
//  WDPagerTitleView.swift
//  WDLive
//
//  Created by scott on 2024/12/6.
//

import UIKit

protocol WDPagerTitleViewDelegate: AnyObject {
    func pagerTitleView(_ pagerTitleView: WDPagerTitleView, targetIndex: Int)
}

class WDPagerTitleView: UIView {
    
    public weak var delegate: WDPagerTitleViewDelegate?
    private let titles: [String]
    private let style: WDPagerStyle
    private var currentIndex = 0
    private var titleLabels = [UILabel]()
    
    init(frame: CGRect, titles: [String], style: WDPagerStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        backgroundColor = .randomColor
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: bounds)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = style.titleIndicatorLineColor
        return view
    }()
}

extension WDPagerTitleView {
    func setupUI(){
        addSubview(scrollView)
        scrollView.addSubview(bottomLineView)
        setupSubTitles()
    }
    
    func setupSubTitles(){
        for (index, title) in titles.enumerated() {
            var x: CGFloat = 0
            let y: CGFloat = 0
            var width: CGFloat = 0
            let height: CGFloat = bounds.height
            if self.style.isTitleScollEnable {
                //可滚动
                width = title.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: style.titleFont)]).width
                if index == 0 {
                    x = style.titleMargin/2.0
                }else {
                    x = titleLabels[index-1].frame.maxX + style.titleMargin
                }
            }else{
                //不可滚动
                width = bounds.width/CGFloat(titles.count)
                x = CGFloat(index) * width
            }
            
            // 设置底部指示器初始位置
            if index == 0 {
                if style.isShowTitleIndicatorLine {
                    bottomLineView.frame = .init(x: x, y: height - style.titleIndicatorLineHeight, width: width, height: style.titleIndicatorLineHeight)
                }
            }
            
            let label = UILabel(frame: .init(x: x, y: y, width: width, height: height))
            label.text = title
            label.tag = index
            label.textAlignment = .center
            label.textColor = index == currentIndex ? style.titleSeletedColor:style.titleNormalColor
            label.font = .systemFont(ofSize: style.titleFont)
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
            scrollView.addSubview(label)
            titleLabels.append(label)
        }
        scrollView.contentSize = .init(width: titleLabels.last!.frame.maxX, height: 0)
    }
    
    private func adjustTitleLabel(toCenter targetLabel: UILabel){
        var offsetX = targetLabel.center.x - bounds.width/2.0
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > scrollView.contentSize.width - bounds.width {
            offsetX = scrollView.contentSize.width - bounds.width
        }
        scrollView.setContentOffset(.init(x: offsetX, y: 0), animated: true)
    }
}

//事件
extension WDPagerTitleView {
    @objc func onTapGesture(_ ges: UIGestureRecognizer){
        guard let targetLabel = ges.view as? UILabel else {
            return
        }
        let sourceLabel = titleLabels[currentIndex]
        currentIndex = targetLabel.tag
        
        sourceLabel.textColor = style.titleNormalColor
        targetLabel.textColor = style.titleSeletedColor
        if style.isTitleScollEnable {
            adjustTitleLabel(toCenter: targetLabel)
        }
        if style.isShowTitleIndicatorLine {
            bottomLineView.frame.origin.x = targetLabel.frame.minX
            bottomLineView.frame.size.width = targetLabel.frame.width
        }
        
        delegate?.pagerTitleView(self, targetIndex: currentIndex)
    }
}

// 联动内容，ContentView滚动影响TitleView
extension WDPagerTitleView: WDPagerContentViewDelegate{
    func pagerContentView(_ pagerContenView: WDPagerContentView, didTo targetIndex: Int) {
        guard targetIndex != currentIndex else {
            return
        }
        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[targetIndex]
        currentIndex = targetIndex
        
        sourceLabel.textColor = style.titleNormalColor
        targetLabel.textColor = style.titleSeletedColor
        
        if style.isShowTitleIndicatorLine {
            bottomLineView.frame.origin.x = targetLabel.frame.minX
            bottomLineView.frame.size.width = targetLabel.frame.width
        }
        
        if style.isTitleScollEnable {
            adjustTitleLabel(toCenter: targetLabel)
        }
    }
    
    func pagerContentView(_ pagerContenView: WDPagerContentView, willTo targetIndex: Int, progress: CGFloat) {
        guard targetIndex != currentIndex else {
            return
        }
//        print("willTo:\(targetIndex),progress:\(progress)")
        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[targetIndex]
        
        guard let sourceColorRBG = UIColor.getRGB(from: style.titleSeletedColor),let targetColorRBG = UIColor.getRGB(from: style.titleNormalColor) else {
            fatalError("颜色转换失败")
        }
        let deltaColor = UIColor.getDeltaColor(style.titleNormalColor,style.titleSeletedColor)
        sourceLabel.textColor = UIColor(sourceColorRBG.0 - deltaColor.0 * progress  , sourceColorRBG.1 - deltaColor.1 * progress , sourceColorRBG.2 - deltaColor.2 * progress )
        targetLabel.textColor = UIColor(targetColorRBG.0 + deltaColor.0 * progress  , targetColorRBG.1 + deltaColor.1 * progress  , targetColorRBG.2 + deltaColor.2 * progress )
        
        if style.isShowTitleIndicatorLine {
            let deltaWidth = targetLabel.frame.width - sourceLabel.frame.width
            let deltaX = targetLabel.frame.minX - sourceLabel.frame.minX
            bottomLineView.frame.origin.x = sourceLabel.frame.minX + deltaX * progress
            bottomLineView.frame.size.width = sourceLabel.frame.width + deltaWidth * progress
        }
    }
    
   
    
}
