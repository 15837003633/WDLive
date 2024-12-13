//
//  HomeViewController.swift
//  WDLive
//
//  Created by scott on 2024/12/6.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor
        setupUI()
    }

    lazy var pagerView: WDPagerView = {
//        let titles = ["热门", "推荐", "附近", "最新", "关注"]
        let titles = ["热门", "推荐", "附近", "最新最新最新", "关注", "才艺才艺", "擦边边", "游戏", "宠物", "关注", "才艺", "擦边", "游戏", "宠物", "关注", "才艺才艺才艺才艺", "擦边", "游戏", "宠物"]
        let vcs = titles.map { _ in
            let vc = HomeChildViewController()
            vc.view.backgroundColor = .randomColor
            return vc
        }
        var style = WDPagerStyle(titleHeight: 44.0)
        style.isTitleScollEnable = true
        style.isShowTitleIndicatorLine = true
        let view = WDPagerView(frame: view.bounds, titles: titles, childVCs: vcs, parentVC: self, style: style)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
}

// UI
extension HomeViewController {
    func setupUI() {
        setupNavBar()
        setupPagerView()
    }

    func setupNavBar() {
        let leftImage = UIImage(named: "input_search")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(onLeftButtonClick))

        let rightImage = UIImage(named: "stream")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(onRightButtonClick))
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 150, height: 35))
        searchBar.placeholder = "请输入搜索内容"
        searchBar.tintColor = .white
        searchBar.barTintColor = .white
        navigationItem.titleView = searchBar
    }

    func setupPagerView() {
        view.addSubview(pagerView)
    }

}

// 事件
extension HomeViewController {
    @objc func onLeftButtonClick() {
        print(#function)
    }

    @objc func onRightButtonClick() {
        print(#function)
    }
}
