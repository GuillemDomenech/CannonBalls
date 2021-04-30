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
    
    private var lastShootTime: Double = 0.0
    private var shootingFrecuency: Double = 30.5 // How many shots per second
    
    private var lastMeteorSpawnTime: Double = 0.0
    private var meteorSpawningDelay: Double = 5 // How many shots per second
    
    private var isPressingDown: Bool = false
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        let bounds = getThisVisibleScreen()
        
        // Setup ground collision
        let groundRect = CGRect(x: -self.size.width/2, y: 0, width: self.size.width, height: self.size.height * 0.15)
        let ground = CreateWall(rect: groundRect)
        ground.physicsBody?.categoryBitMask = CollisionTypes.ground.rawValue
        ground.physicsBody?.collisionBitMask = CollisionTypes.meteor.rawValue
        ground.name = "Ground"
        self.addChild(ground)
        
        let ceilingRect = CGRect(x: -self.size.width/2, y: bounds.maxY, width: self.size.width, height: self.size.height * 0.15)
        let ceiling = CreateWall(rect: ceilingRect)
        ceiling.physicsBody?.categoryBitMask = CollisionTypes.ceiling.rawValue
        ceiling.physicsBody?.contactTestBitMask = CollisionTypes.missile.rawValue
        ceiling.name = "Ceiling"
        self.addChild(ceiling)
        
        //Ball collision test
        redBall = SKShapeNode(circleOfRadius: 20)
        redBall.fillColor = .red;
        redBall.position = CGPoint(x: 0, y: self.size.height * 0.9)
        redBall.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        redBall.physicsBody?.categoryBitMask = CollisionTypes.meteor.rawValue
        redBall.physicsBody?.collisionBitMask = CollisionTypes.ground.rawValue |
            CollisionTypes.wall.rawValue | CollisionTypes.player.rawValue
        redBall.physicsBody?.contactTestBitMask = CollisionTypes.ground.rawValue | CollisionTypes.wall.rawValue | CollisionTypes.player.rawValue | CollisionTypes.wall.rawValue
        redBall.physicsBody?.applyForce(CGVector(dx: -5000.0, dy: 0.0))
        redBall.name = "Meteor"
        
        // Background clouds
        
        let clouds1 = UIImage(named: "clouds1")!
        let clouds1Scroller = InfiniteScrollingBackground(images: [clouds1, clouds1], scene: self, scrollDirection: .right, transitionSpeed: 2.5, positionY: frame.height*0.65)
        clouds1Scroller?.sprites.forEach {
            $0.xScale = 0.4
            $0.yScale = 0.4
        }
        clouds1Scroller?.zPosition = -1
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
        lWall.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        lWall.name = "Wall"
        self.addChild(lWall)
        
        let rWallRect = CGRect(x: gameRect.width/2, y: 0, width: 1, height: self.size.height)
        let rWall = CreateWall(rect: rWallRect)
        rWall.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        rWall.name = "Wall"
        self.addChild(rWall)
        
        // Player
        player = self.childNode(withName: "Cannon") as? SKSpriteNode
        player.physicsBody?.affectedByGravity = true
        //player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height + 80), center: CGPoint(x: 0, y: -20))
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.name = "Player"
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
        //wall.physicsBody?.categoryBitMask = 0b0001
        return wall
    }
    
    func touchDown(atPoint pos : CGPoint) {
        //redBall.physicsBody?.applyForce(CGVector(dx: -5000.0, dy: 500.0))
        posX = pos.x
        isPressingDown = true
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        posX = pos.x
        isPressingDown = true
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //redBall.physicsBody?.applyForce(CGVector(dx: 2000.0, dy: 500.0))
        
        posX = pos.x
        isPressingDown = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
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
        
        // Calculate velX to rotate wheels
        var currPosX = player.position.x
        velX = (currPosX - lastPosX)/CGFloat(deltaT)
        
        pWheel1.zRotation += (-velX/80) * CGFloat(deltaT)
        pWheel2.zRotation += (-velX/80) * CGFloat(deltaT)
        
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
        lastFrameTime = currentTime
        lastPosX = currPosX
        
        // Check if should shoot
        if ((currentTime - lastShootTime) > 1.0/shootingFrecuency && isPressingDown) {
            ShootMisile()
            lastShootTime = currentTime
        }
        
        if((currentTime - lastMeteorSpawnTime) > meteorSpawningDelay) {
            SpawnMeteor()
            lastMeteorSpawnTime = currentTime
        }
        
    }
    
    func SpawnMeteor() {
        let bounds = getThisVisibleScreen()
        let meteor = Meteor(pos: CGPoint(x: 0, y: bounds.maxY*0.8), scale: 0.6, col: .red, sceneRef: self, sideSpawn: true, shouldSplit: true)
    }
    
    func ShootMisile() {
        let sprite = SKSpriteNode(imageNamed: "missile")
        sprite.position = CGPoint(x: player.frame.midX, y: player.frame.maxY)
        sprite.name = "Missile"
        sprite.zPosition = 1
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 1300)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.categoryBitMask = CollisionTypes.missile.rawValue
        sprite.physicsBody?.collisionBitMask = 0
        sprite.physicsBody?.contactTestBitMask = CollisionTypes.meteor.rawValue
        addChild(sprite)
        
        
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
