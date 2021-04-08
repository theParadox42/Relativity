import SpriteKit
import Math

public let c: CGFloat = 1

let defaultPosition = CGPoint(0, 0)
let defaultDirection = CGVector(1, 0)
let defaultRadius: CGFloat = 10

public class LightRay {
    
    public var position: CGPoint
    var direction: CGVector
    var radius: CGFloat
    public var node: SKShapeNode
    
    // init
    public init(position: CGPoint?, direction: CGVector?, radius: CGFloat?) {
        self.position = position ?? defaultPosition
        self.direction = direction?.normalized(setZeroTo: defaultDirection) ?? defaultDirection
        self.radius = radius ?? defaultRadius
        self.node = SKShapeNode(circleOfRadius: self.radius)
    }

    // makes sure direction fits in mag 1
    func checkDirection () {
        direction = direction.magnitude() == 1 ? direction: direction.normalized(setZeroTo: CGVector(1, 0))
    }
    // Move position according to direction and speed
    public func move(simulationSpeed simSpeed: CGFloat) {
        position += direction * c * simSpeed
        node.position = position
    }
    // Doesn't require sim speed
    public func move() {
        checkDirection()
        
        move(simulationSpeed: 1)
    }
    // retrieve direction
    public func getDirection() -> CGVector {
        return direction
    }
    // sets direction to vector and then normalizes
    public func setDirection(vec newVector: CGVector) {
        direction = newVector.normalized(setZeroTo: CGVector(1, 0))
    }
    // sets direction to vector with mag 1 and x-value
    public func setDX(x newX: CGFloat) {
        // creates x from newX bounded to -1,1
        let x = abs(Int(newX)) < 1 ? newX : newX > 0 ? 1 : -1
        // sets values
        direction.dx = x
        direction.dy = sqrt(1 - x * x)
    }
    // does same but for y
    public func setDY(y newY: CGFloat) {
        let y = abs(Int(newY)) < 1 ? newY : newY > 0 ? 1 : -1
        // sets values
        direction.dx = sqrt(1 - y * y)
        direction.dy = y
    }
    
    // Collisions
    // Man this was a struggle but I did it all
    public func keepOutOfRect(rect: CGRect) {
        // check if it applies
        if !(position.x + radius > rect.minX && position.y + radius > rect.minY && position.x - radius < rect.maxX && position.y - radius < rect.maxY) {
            return
        }
        /*
         Collision theory
         ___*send up*__
         \MMMMMMMMMMMM/
         >\MMMMMMMMMM/<
         >>\MMMMMMMM/<<
         >>>||||||||<<< *send right*
         >>/WWWWWWWW\<<
         >/WWWWWWWWWW\<
         /WWWWWWWWWWWW\
         __*send down*_
         */
        // Left Bound:
        if position.x < rect.midX &&
            ((position.y < rect.midY && position.y > rect.minY + position.x - rect.minX) ||
            (position.y > rect.midY && position.y < rect.maxY - position.x + rect.minX)) {
            direction.dx = -abs(direction.dx)
            position.x += direction.dx * 2
        } else
        // Right Bound:
        if position.x > rect.midX &&
            ((position.y < rect.midY && position.y > rect.minY - position.x + rect.maxX) || 
            (position.y > rect.midY && position.y < rect.maxY + position.x - rect.maxX)) {
            direction.dx = abs(direction.dx)
            position.x += direction.dx * 2
        }
        // Upper Bound
        if position.y < rect.midY && 
            ((position.x < rect.midX && position.x > rect.minX + position.y - rect.minY) ||
            (position.x > rect.midX && position.x < rect.maxX - position.y + rect.minY)) {
            direction.dy = -abs(direction.dy)
            position.y += direction.dy * 2
        } else 
        // Lower Bound
        if position.y > rect.midY &&
            ((position.x < rect.midX && position.x > rect.minX - position.y + rect.maxY) ||
            (position.x > rect.midX && position.x < rect.maxX + position.y - rect.maxY)) {
            direction.dy = abs(direction.dy)
            position.y += direction.dy * 2
        }
    }
    public func keepInRect(rect: CGRect) {
        if position.x - radius > rect.minX && position.y - radius > rect.minY && position.x + radius < rect.maxX && position.y + radius < rect.maxY {
            return
        }
        // Horizontal collision
        if position.x - radius < rect.minX || position.x + radius > rect.maxX {
            if position.x > rect.midX {
                direction.dx = -abs(direction.dx)
            } else {
                direction.dx = abs(direction.dx)
            }
        }
        // Vertical Collision
        if (position.y - radius < rect.minY || position.y + radius > rect.maxY) {
            if position.y > rect.midY {
                direction.dy = -abs(direction.dy)
                position.y += direction.dy * 2
            } else {
                direction.dy = abs(direction.dy)
                position.y += direction.dy * 2
            }
        }
    }
    
}