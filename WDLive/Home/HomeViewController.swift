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
            let vc = UIViewController()
            vc.view.backgroundColor = .randomColor
            return vc
        }
        var style = WDPagerStyle(titleHeight: 44.0)
        style.isTitleScollEnable = true
        style.isShowTitleIndicatorLine = true
        let view = WDPagerView(frame: view.bounds, titles: titles, childVCs: vcs, parentVC: self, style: style)
        return view
    }()
}

//UI
extension HomeViewController {
    func setupUI(){
        setupNavBar()
        setupPagerView()
    }
    
    func setupNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "input_search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onLeftButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "stream")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(onRightButtonClick))
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 150, height: 35))
        searchBar.placeholder = "请输入搜索内容"
        searchBar.tintColor = .white
        searchBar.barTintColor = .white
        navigationItem.titleView = searchBar
    }
    
    func setupPagerView(){
        view.addSubview(pagerView)
    }
    
}

//事件
extension HomeViewController {
    @objc func onLeftButtonClick(){
        print(#function)
    }
    
    @objc func onRightButtonClick(){
        print(#function)
    }
}
