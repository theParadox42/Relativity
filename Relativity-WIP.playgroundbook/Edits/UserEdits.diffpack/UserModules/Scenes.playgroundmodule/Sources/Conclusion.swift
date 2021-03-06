import SpriteKit
import Entities
import Math

public class Conclusion: SimScene, MeterDelegate {
    
    let simBounds = CGRect(x: superBounds.minX, y: superBounds.minY, width: superBounds.width - graphWidth, height: superBounds.height)
    let graphBounds = CGRect(x: superBounds.maxX - graphWidth, y: superBounds.minY, width: graphWidth, height: superBounds.height)
    
    let meterRadius: CGFloat
    
    let rocketMeter: Meter
    let rocketSpeedLabel: SpeedLabel
    
    let rocket: SKNode
    let rocketWidth: CGFloat
    let rocketClock: TimeClock
    var rocketVelocity: CGFloat = 0
    let earth: SKSpriteNode
    let earthClock: TimeClock
    
    public override init() {
        
        meterRadius = graphBounds.width / 2
        rocketMeter = Meter(radius: meterRadius, vector: CGVector(0, 1), degrees: [0, CGFloat.pi / 2], labelText: "Rocket Velocity", xAxisLabelText: "Speed", yAxisLabelText: "Time")
        rocketSpeedLabel = SpeedLabel(subject: "rocket", width: simBounds.width)
        
        rocketWidth = simBounds.width / 3
        rocket = SKNode()
        let rocketPath = SKShapeNode(path: RocketPath.rocketPath.cgPath)
        rocketPath.setScale(rocketWidth /  20)
        rocketPath.fillColor = #colorLiteral(red: 0.7098039388656616, green: 0.10196079313755035, blue: 0.0, alpha: 1.0)
        rocketPath.lineWidth = 0
        rocketPath.zRotation = -.pi / 2
        rocket.addChild(rocketPath)
        rocketClock = TimeClock(radius: rocketWidth / 6)
        rocketClock.position = CGPoint(rocketWidth / 3, rocketWidth / 6)
        rocket.addChild(rocketClock)
        
        earth = SKSpriteNode(imageNamed: "worldwide.png")
        earth.setScale(simBounds.width / 2 / 256)
        earthClock = TimeClock(radius: 35)
        earthClock.position = CGPoint(60, 80)
        earth.addChild(earthClock)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        backgroundColor = #colorLiteral(red: 0.06665531545877457, green: 0.06667457520961761, blue: 0.06665278226137161, alpha: 1.0)
        
        let graphBG = SKShapeNode(rect: graphBounds)
        graphBG.fillColor = .black
        graphBG.lineWidth = 0
        
        rocket.position = CGPoint(simBounds.midX, simBounds.minY + simBounds.height * 7 / 24)
        
        rocketMeter.position = CGPoint(graphBounds.midX - meterRadius / 2, graphBounds.midY)
        rocketMeter.delegate = self
        rocketSpeedLabel.position = CGPoint(simBounds.midX, simBounds.midY)
        
        earth.position = CGPoint(simBounds.midX, simBounds.minY + simBounds.height * 17 / 24)
        
        addChild(rocket)
        addChild(earth)
        
        addChild(graphBG)
        addChild(rocketMeter)
        addChild(rocketSpeedLabel)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        
        rocketClock.tick(whileMovingAtSpeed: rocketVelocity, withSimSpeed: simSpeed)
        earthClock.tick(whileMovingAtSpeed: 0, withSimSpeed: simSpeed)
        
        rocket.position.x += rocketVelocity * simSpeed
        if rocket.position.x - rocketWidth / 2 > simBounds.maxX {
            rocket.position.x = simBounds.minX - rocketWidth / 2
        }
        
        rocket.xScale = sqrt(1 - rocketVelocity * rocketVelocity)
    }
    
    public func recieveUpdatedMeterVector(vector: CGVector) {
        rocketVelocity = vector.dx
        rocketSpeedLabel.updateWithVelocity(of: vector.dx)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(touchPosition: touches.first!.location(in: self))
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(touchPosition: touches.first!.location(in: self))
    }
    func touched(touchPosition: CGPoint) {
        rocketMeter.touched(touchPos: touchPosition)
    }
    
}
