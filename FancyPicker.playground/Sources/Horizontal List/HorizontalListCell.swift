import UIKit

class HorizontalListCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = UIColor.white
        return label
    }()

    var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.center = CGPoint(x: 0.5 * bounds.width, y: 0.5 * bounds.height)
    }
}
