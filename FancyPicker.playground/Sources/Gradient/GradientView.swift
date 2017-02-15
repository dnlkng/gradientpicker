import UIKit

public class GradientView: UIView {
    private var start = Color()
    private var end = Color()
    
    public var gradient: Gradient? {
        didSet {
            guard let gradient = gradient, gradient != oldValue else { return }
            start = gradient.start
            end = gradient.end
            setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: [UIColor(color: start).cgColor, UIColor(color: end).cgColor] as NSArray,
                                        locations: [0, 1]),
            let overlay = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: [UIColor(white: 1, alpha: 0.5).cgColor, UIColor(white: 0, alpha: 0.5).cgColor] as NSArray,
                                     locations: [0, 1]) else { return }
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: rect.size.width, y: 0)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        context.setBlendMode(.overlay)
        
        context.drawLinearGradient(overlay, start: startPoint, end: endPoint, options: [])
    }
}

