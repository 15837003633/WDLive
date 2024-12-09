
import UIKit

/*
 自定义layout三部曲：
 1.prepar 用于提前准备好数据
 2.collectionViewContentSize 返回可滚动的大小
 3.layoutAttributesForElements 返回cell的布局
 */

public protocol WDWaterfallCollectionLayoutDataSource: AnyObject {
    func heightForItems(in waterfallCollectionLayout: WDWaterfallCollectionLayout) -> CGFloat
}
open class WDWaterfallCollectionLayout: UICollectionViewFlowLayout {
    open var col: Int = 3
    open weak var dataSource: WDWaterfallCollectionLayoutDataSource?
    
    
    private var itemAttrs = [UICollectionViewLayoutAttributes]()
    private lazy var totalColHeights: [CGFloat] = Array(repeating: self.sectionInset.top, count: self.col)
    
}

extension WDWaterfallCollectionLayout {
    open override func prepare() {
        super.prepare()
        
        let width: CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * (CGFloat(col) - 1)) / CGFloat(col)

        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        /*
         Q：优化上拉加载更多
         方案1：从itemAttrs.count开始遍历，，减少不必要的计算。
         方案2：每次reloadData时会调用prepare中清空itemAttrs和totalColHeights，全部重新计算
         */

        for i in itemAttrs.count..<itemCount {
            let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            let minY = totalColHeights.min()!
            let minY_index = totalColHeights.firstIndex(of: minY)!
            
            //计算frame
            let x: CGFloat = sectionInset.left + (width + minimumInteritemSpacing) * CGFloat(minY_index)
            let y: CGFloat = minY
            guard let height: CGFloat = dataSource?.heightForItems(in: self) else {
                fatalError("must implement datasource")
            }
            
            attrs.frame = CGRect(x: x, y: y, width: width, height: height)
            
            itemAttrs.append(attrs)
            totalColHeights[minY_index] = attrs.frame.maxY + minimumLineSpacing
        }
        
    }
    
    open override var collectionViewContentSize: CGSize {
        return .init(width: 0, height: totalColHeights.max()! + sectionInset.bottom - minimumLineSpacing)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttrs
    }
}
