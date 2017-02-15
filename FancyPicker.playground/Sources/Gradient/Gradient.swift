import UIKit

public struct Color: Equatable {
    let red: Float
    let green: Float
    let blue: Float
    
    public init(red: Float = 0, green: Float = 0, blue: Float = 0) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}

public func == (left: Color, right: Color) -> Bool {
    return left.red == right.red &&
        left.green == right.green &&
        left.blue == right.blue
}

public struct Gradient: Equatable {
    let start: Color
    let end: Color
    
    public init(start: Color, end: Color) {
        self.start = start
        self.end = end
    }
}

extension Gradient {
    public func clipped(to range: VisibleRange) -> Gradient {
        return Gradient(start: color(at: range.start), end: color(at: range.end))
    }
    
    func color(at point: Float) -> Color {
        let red = start.red + point * (end.red - start.red)
        let green = start.green + point * (end.green - start.green)
        let blue = start.blue + point * (end.blue - start.blue)
        
        return Color(red: red, green: green, blue: blue)
    }
}

public func == (left: Gradient, right: Gradient) -> Bool {
    return left.start == right.start &&
        left.end == right.end
}

extension UIColor {    
    convenience init(color: Color) {
        self.init(displayP3Red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: 1)
    }
}
