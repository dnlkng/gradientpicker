import UIKit
import PlaygroundSupport

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 300))

PlaygroundPage.current.liveView = containerView

class Picker: UIView, HorizontalListEventHandler {
    let gradientView = GradientView()
    let horizontalList = HorizontalList()

    let gradient = Gradient(start: Color(red: 0.0/255, green: 255.0/255, blue: 128.0/255),
                               end: Color(red: 0.0/255, green: 85.0/255, blue: 255.0/255))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientView.gradient = gradient
        addSubview(gradientView)
        
        horizontalList.items = (1...50).map { String($0) }
        horizontalList.eventHandler = self
        addSubview(horizontalList)
        
        updateGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientView.frame = bounds
        horizontalList.frame = bounds
    }
    
    func horizontalList(_ horizontalList: HorizontalList, didScrollInto visibleRange: VisibleRange) {
        updateGradient()
    }
    
    func updateGradient() {
        gradientView.gradient = gradient.clipped(to: horizontalList.visibleRange)
    }
}

let picker = Picker(frame: CGRect(x: 0, y: 90, width: 320, height: 120))
containerView.addSubview(picker)
