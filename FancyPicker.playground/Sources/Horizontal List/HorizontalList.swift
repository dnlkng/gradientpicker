import UIKit

public typealias VisibleRange = (start: Float, end: Float)

public protocol HorizontalListEventHandler: class {
    func horizontalList(_ horizontalList: HorizontalList, didScrollInto visibleRange: VisibleRange)
}

public class HorizontalList: UIControl {
    public weak var eventHandler: HorizontalListEventHandler?
    
    fileprivate let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(HorizontalListCell.self, forCellWithReuseIdentifier: "cell")
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        
        return view
    }()
    
    public var items: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        collectionView.frame = bounds
    }
    
    public var visibleRange: VisibleRange {
        let totalWidth = collectionView.contentSize.width + collectionView.contentInset.left
        let scrolledOffsetStart = collectionView.contentOffset.x
        let scrolledOffsetEnd = scrolledOffsetStart + collectionView.bounds.width
        
        if scrolledOffsetStart < totalWidth && scrolledOffsetEnd <= totalWidth {
            return (start: Float(scrolledOffsetStart / totalWidth), end: Float(scrolledOffsetEnd / totalWidth))
        } else {
            return (start: 1, end: 1)
        }
    }
}

extension HorizontalList: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let cell = cell as? HorizontalListCell {
            cell.title = items[indexPath.row]
        }
        
        return cell
    }
}

extension HorizontalList: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: collectionView.bounds.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: itemWidth, bottom: 0, right: itemWidth)
    }
    
    private var itemWidth: CGFloat {
        return 0.5 * collectionView.bounds.width
    }
}

extension HorizontalList: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        eventHandler?.horizontalList(self, didScrollInto: visibleRange)
    }
}
