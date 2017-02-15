import UIKit

class HorizontalListLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()

        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        var resultContentOffset = proposedContentOffset

        let visibleRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)

        let proposedCenterX = CGFloat(proposedContentOffset.x + 0.5 * collectionView.bounds.width)

        let attributesToCenter = layoutAttributesForElements(in: visibleRect)?
            .filter { $0.representedElementCategory == UICollectionElementCategory.cell }
            .sorted(by: { (left, right) -> Bool in
                return abs(left.center.x - proposedCenterX) < abs(right.center.x - proposedCenterX)
            })
            .first

        if let attributesToCenter = attributesToCenter {
            let offsetAdjustment = attributesToCenter.center.x - proposedCenterX

            var nextOffset = proposedContentOffset.x + offsetAdjustment

            repeat {
                resultContentOffset.x = nextOffset

                let deltaX = proposedContentOffset.x - collectionView.contentOffset.x

                if deltaX == 0 || velocity.x == 0 { break }
                if velocity.x > 0 && deltaX > 0 { break }
                if velocity.x < 0 && deltaX < 0 { break }

                let snapStep = itemSize.width + minimumLineSpacing

                if velocity.x > 0 {
                    nextOffset += snapStep
                } else if velocity.x < 0 {
                    nextOffset -= snapStep
                }

            } while isValid(offset: nextOffset)
        }

        return resultContentOffset
    }

    func isValid(offset: CGFloat) -> Bool {
        guard let collectionView = collectionView else { return true }

        let minContentOffset = -collectionView.contentInset.left
        let maxContentOffset = minContentOffset + collectionView.contentSize.width - itemSize.width
        return offset >= minContentOffset && offset <= maxContentOffset
    }
}
