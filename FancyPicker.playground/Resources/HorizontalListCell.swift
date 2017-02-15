import UIKit
import PureLayout

class HorizontalListCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var viewModel: ListItemViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            descriptionLabel.text = viewModel?.description
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        if let view = UIView.load(from: "HorizontalListCell", owner: self) {
            addSubview(view)
            view.autoPinEdgesToSuperviewEdges()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
