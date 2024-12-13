//
//  HomeChildViewController.swift
//  WDLive
//
//  Created by scott on 2024/12/7.
//

import UIKit

class HomeChildViewController: UIViewController {

    private var cellCount = 30
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var collectionView: UICollectionView = {
        let layout = WDWaterfallCollectionLayout()
        layout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.dataSource = self
        layout.col = Int(arc4random_uniform(3) + 2)
        let collectionView = UICollectionView(frame: view!.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}

extension HomeChildViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .randomColor
        if indexPath.row == cellCount - 1 {
            cellCount += 30
            collectionView.reloadData()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Room", bundle: Bundle.main)
        let roomVC = storyBoard.instantiateInitialViewController()
        self.navigationController?.pushViewController(roomVC!, animated: true)
    }
}

extension HomeChildViewController: WDWaterfallCollectionLayoutDataSource {
    func heightForItems(in waterfallCollectionLayout: WDWaterfallCollectionLayout) -> CGFloat {
        return CGFloat(arc4random_uniform(150)+50)
    }
}
