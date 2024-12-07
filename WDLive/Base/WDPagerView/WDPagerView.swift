//
//  WDPagerView.swift
//  WDLive
//
//  Created by scott on 2024/12/6.
//

import UIKit

class WDPagerView: UIView {
    
    let titles: [String]
    let childVCs: [UIViewController]
    let parentVC: UIViewController
    let style: WDPagerStyle
    
    init(frame: CGRect, titles: [String], childVCs: [UIViewController], parentVC: UIViewController, style: WDPagerStyle) {
        self.titles = titles
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleView: WDPagerTitleView = {
        let view = WDPagerTitleView(frame: .init(x: 0, y: 0, width: bounds.width, height: style.titleHeight), titles: self.titles, style: self.style)
        return view
    }()
    
    lazy var contenView: WDPagerContentView = {
        let view = WDPagerContentView(frame: .init(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight), childVCs: self.childVCs, parentVC: self.parentVC,style: self.style)
        return view
    }()
    
}

//UI
extension WDPagerView{
    func setupUI(){
        addSubview(self.titleView)
        addSubview(self.contenView)
        titleView.delegate = contenView
        contenView.delegate = titleView

    }
}