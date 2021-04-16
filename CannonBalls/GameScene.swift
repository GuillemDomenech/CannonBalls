//
//  GameScene.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 15/04/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var redBall: SKShapeNode!
    private var posX: CGFloat = 0
    private var player: SKSpriteNode!
    private var pWheel1: SKSpriteNode!
    private var pWheel2: SKSpriteNode!
    private var velX: CGFloat = 0
    private var deltaT: Double = 0
    private var lastFrameTime = TimeInterval()
    private var lastPosX: CGFloat = 0
    
    
    override func didMove(to view: SKView) {
                
        //self.setScale(UIScreen.main.bounds.size)
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        // Setup ground collision
        let groundRect = CGRect(x: -self.size.width/2, y: 0, width: self.size.width, height: self.size.height * 0.15)
        let ground = CreateWall(rect: groundRect)
        self.addChild(ground)
        
        //Ball collision test
        redBall = SKShapeNode(circleOfRadius: 20)
        redBall.fillColor = .red;
        redBall.position = CGPoint(x: 0, y: self.size.height * 0.9)
        redBall.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        redBall.physicsBody?.collisionBitMask = 0b0001
        redBall.physicsBody?.applyForce(CGVector(dx: -5000.0, dy: 0.0))
        self.addChild(redBall)
        redBall.name = "Ball"
        
        // Background clouds
        
        let clouds1 = UIImage(named: "clouds1")!
        let clouds1Scroller = InfiniteScrollingBackground(images: [clouds1, clouds1], scene: self, scrollDirection: .right, transitionSpeed: 2.5, positionY: frame.height*0.65)
        clouds1Scroller?.sprites.forEach {
            $0.xScale = 0.4
            $0.yScale = 0.4
        }
        clouds1Scroller?.zPosition = 0
        clouds1Scroller?.scroll()
        
        let clouds2 = UIImage(named: "clouds2")!
        let clouds2Scroller = InfiniteScrollingBackground(images: [clouds2, clouds2], scene: self, scrollDirection: .right, transitionSpeed: 1.5, positionY: frame.height*0.6)
        clouds2Scroller?.sprites.forEach {
            $0.xScale = 0.6
            $0.yScale = 0.5
        }
        clouds2Scroller?.zPosition = -2
        clouds2Scroller?.scroll()
        
        // Left and right walls
        let gameRect = getThisVisibleScreen()
        let lWallRect = CGRect(x: -gameRect.width/2, y: 0, width: 1, height: self.size.height)
        let lWall = CreateWall(rect: lWallRect)
        self.addChild(lWall)
        
        let rWallRect = CGRect(x: gameRect.width/2, y: 0, width: 1, height: self.size.height)
        let rWall = CreateWall(rect: rWallRect)
        self.addChild(rWall)
        
        // Player
        player = self.childNode(withName: "Cannon") as? SKSpriteNode
        player.physicsBody?.affectedByGravity = true
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height + 80), center: CGPoint(x: 0, y: -20))
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        lastPosX = player.position.x
        pWheel1 = player.childNode(withName: "Wheel1") as? SKSpriteNode
        pWheel2 = player.childNode(withName: "Wheel2") as? SKSpriteNode
        
    }
    
    func CreateWall(rect: CGRect) -> SKShapeNode {
        let wall = SKShapeNode(rect: rect)
        //wall.strokeColor = .red
        wall.lineWidth = 0
        wall.zPosition = 1
        wall.physicsBody = SKPhysicsBody(edgeChainFrom: wall.path!)
        wall.physicsBody?.restitution = 1
        wall.physicsBody?.categoryBitMask = 0b0001
        return wall
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            //self.addChild(n)
            
            redBall.physicsBody?.applyForce(CGVector(dx: -5000.0, dy: 500.0))
            
            posX = pos.x
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            //self.addChild(n)
            
            posX = pos.x
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            //self.addChild(n)
            redBall.physicsBody?.applyForce(CGVector(dx: 2000.0, dy: 500.0))
            
            posX = pos.x
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        deltaT = currentTime - lastFrameTime
        
        var currPosX = player.position.x
        velX = (currPosX - lastPosX)/CGFloat(deltaT)
        
        pWheel1.zRotation += (-velX/100) * CGFloat(deltaT)
        pWheel2.zRotation += (-velX/100) * CGFloat(deltaT)
        
        //Move player to position X
        player.position.x = lerp(from: currPosX, to: posX, t: 0.2)
        //Check bounds
        let bounds = getThisVisibleScreen()
        let playerWidth = player.size.width/2 + 37
        if (player.position.x - playerWidth < -bounds.width/2) {
            player.position.x = -bounds.width/2 + playerWidth
        } else if (player.position.x + playerWidth > bounds.width/2) {
            player.position.x = bounds.width/2 - playerWidth
        }
        
        print("vel: " , velX)
        lastFrameTime = currentTime
        lastPosX = currPosX
    }
    func getThisVisibleScreen() -> CGRect {
        return getVisibleScreen(sceneWidth: frame.width, sceneHeight: frame.height, viewWidth: view!.bounds.width, viewHeight: view!.bounds.height)
    }
    
    func getVisibleScreen(sceneWidth: CGFloat, sceneHeight: CGFloat, viewWidth: CGFloat, viewHeight: CGFloat) -> CGRect {
        var x: CGFloat = 0
        var y: CGFloat = 0
        var sceneWidth = sceneWidth
        var sceneHeight = sceneHeight

        let deviceAspectRatio = viewWidth/viewHeight
        let sceneAspectRatio = sceneWidth/sceneHeight

        //If the the device's aspect ratio is smaller than the aspect ratio of the preset scene dimensions, then that would mean that the visible width will need to be calculated
        //as the scene's height has been scaled to match the height of the device's screen. To keep the aspect ratio of the scene this will mean that the width of the scene will extend
        //out from what is visible.
        //The opposite will happen in the device's aspect ratio is larger.
        if deviceAspectRatio < sceneAspectRatio {
            let newSceneWidth: CGFloat = (sceneWidth * viewHeight) / sceneHeight
            let sceneWidthDifference: CGFloat = (newSceneWidth - viewWidth)/2
            let diffPercentageWidth: CGFloat = sceneWidthDifference / (newSceneWidth)

            //Increase the x-offset by what isn't visible from the lrft of the scene
            x = diffPercentageWidth * sceneWidth
            //Multipled by 2 because the diffPercentageHeight is only accounts for one side(e.g right or left) not both
            sceneWidth = sceneWidth - (diffPercentageWidth * 2 * sceneWidth)
        } else {
            let newSceneHeight: CGFloat = (sceneHeight * viewWidth) / sceneWidth
            let sceneHeightDifference: CGFloat = (newSceneHeight - viewHeight)/2
            let diffPercentageHeight: CGFloat = abs(sceneHeightDifference / (newSceneHeight))

            //Increase the y-offset by what isn't visible from the bottom of the scene
            y = diffPercentageHeight * sceneHeight
            //Multipled by 2 because the diffPercentageHeight is only accounts for one side(e.g top or bottom) not both
            sceneHeight = sceneHeight - (diffPercentageHeight * 2 * sceneHeight)
        }

        let visibleScreenOffset = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(sceneWidth), height: CGFloat(sceneHeight))
        return visibleScreenOffset
    }
    
    func lerp(from: CGFloat, to: CGFloat, t: CGFloat) -> CGFloat
    {
        return from + (to - from) * t;
    }
    
    func deg2rad(_ number: CGFloat) -> CGFloat {
        return number * .pi / 180
    }

}
