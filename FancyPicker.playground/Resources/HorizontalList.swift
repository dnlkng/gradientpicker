import UIKit
import PureLayout

protocol HorizontalListEventHandler: class {
    func horizontalList(_ horizontalList: HorizontalList, didScrollInto visibleRange: VisibleRange)
    func horizontalList(_ horizontalList: HorizontalList, didScrollTo item: Int?)
}

@IBDesignable class HorizontalList: UIControl {
    weak var eventHandler: HorizontalListEventHandler?
    let feedbackProvider = HorizontalListFeedbackProvider()

    let collectionView: UICollectionView = {
        let flowLayout = HorizontalListLayout()

        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(HorizontalListCell.self, forCellWithReuseIdentifier: "cell")
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = false
        view.backgroundColor = UIColor.clear
        view.decelerationRate = UIScrollViewDecelerationRateNormal

        return view
    }()

    var viewModel: ListViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel != oldValue else { return }

            let oldItems: [ListItemViewModel] = oldValue?.items ?? []

            if viewModel.items != oldItems {
                collectionView.reloadData()
                setNeedsLayout()
                layoutIfNeeded()
            }

            if oldValue == nil {
                scroll(to: viewModel.selectedIndex, animated: false)
            }
        }
    }

    func scroll(to index: Int, animated: Bool) {
        let offset = cellWidth * CGFloat(index)
        centralItem = index
        collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: animated)
    }

    var itemWidthRatio: Double = 0.5
    var centralItem: Int?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
    }

    func stopScrolling() {
        collectionView.isScrollEnabled = false
        collectionView.isScrollEnabled = true
    }

    var visibleRange: VisibleRange {
        let totalWidth = collectionView.contentSize.width + collectionView.contentInset.left
        if totalWidth <= 0 { return (start: 0, end: 0) }

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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        if let cell = cell as? HorizontalListCell {
            cell.viewModel = viewModel?.items[indexPath.row]
        }

        return cell
    }
}

extension HorizontalList: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }

    var itemWidth: CGFloat {
        return CGFloat(itemWidthRatio) * collectionView.bounds.width
    }

    fileprivate var sideInset: CGFloat {
        return 0.5 * (bounds.width - itemWidth)
    }
}

extension HorizontalList: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !ignoreScrollEvents else { return }

        notifyOfVisibleRangeChange()
        updateCentralItem()
    }

    var ignoreScrollEvents: Bool {
        return false
    }

    private func notifyOfVisibleRangeChange() {
        eventHandler?.horizontalList(self, didScrollInto: visibleRange)
    }

    fileprivate func updateCentralItem() {
        guard let newCentralItem = centralIndex,
            centralItem != newCentralItem,
            let cell = collectionView.cellForItem(at: IndexPath(item: newCentralItem, section: 0)) else { return }

        let screenCenterX = CGFloat(itemWidthRatio) * collectionView.bounds.width + collectionView.contentOffset.x
        let distance = abs(cell.center.x - screenCenterX)
        let treshold: CGFloat = 10

        if distance < treshold {
            let firstTime = centralItem == nil
            centralItem = newCentralItem

            if !firstTime {
                notifyOfCentralItemChange()
                feedbackProvider.provideFeedback()
            }
        }
    }

    private func notifyOfCentralItemChange() {
        eventHandler?.horizontalList(self, didScrollTo: centralItem)
    }

    private var centralIndex: Int? {
        let screenCenterX = cellWidth + collectionView.contentOffset.x

        let cellInCenter = collectionView.visibleCells
            .sorted { (left, right) -> Bool in
                return abs(left.center.x - screenCenterX) < abs(right.center.x - screenCenterX)
            }
            .first

        if let cellInCenter = cellInCenter {
            return collectionView.indexPath(for: cellInCenter)?.row
        } else {
            return nil
        }
    }

    fileprivate var cellWidth: CGFloat {
        return CGFloat(itemWidthRatio) * collectionView.bounds.width
    }
}
