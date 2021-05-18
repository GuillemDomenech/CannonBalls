//
//  Meteor.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 30/04/2021.
//

import Foundation
import SpriteKit
import GameplayKit

class Meteor: SKSpriteNode {
    
    var lives: Int
    var livesAtStart: Int
    var livesText: SKLabelNode!
    let sceneRef: GameScene
    let splitCount: Int
    
    init(pos: CGPoint, scale: CGFloat, col: SKColor, totalLives: Int = 5, sceneRef: GameScene, sideSpawn: Bool = false, splitCount: Int) {
        let pos = pos
        let scale = scale
        let col = col
        lives = totalLives
        livesAtStart = totalLives
        self.sceneRef = sceneRef
        self.splitCount = splitCount
        // Create meteor
        let texture = SKTexture(imageNamed: "meteor")
        super.init(texture: texture , color: col, size: texture.size())
        self.colorBlendFactor = 0.8
        self.position = pos
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.categoryBitMask = CollisionTypes.meteor.rawValue
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = CollisionTypes.ground.rawValue | CollisionTypes.wall.rawValue | CollisionTypes.player.rawValue
        self.setScale(scale)
        self.name = "Meteor"
        
        // Create lives text
        livesText = SKLabelNode(text: String(totalLives))
        livesText.fontSize = 186
        livesText.fontName = "Arial-BoldMT"
        livesText.fontColor = SKColor.white
        livesText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        livesText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        livesText.zPosition = 1
        self.addChild(livesText)
        
        if sideSpawn {
            // Do initial movement
            let lSide = pos.x < 0
            let border = sceneRef.getThisVisibleScreen()
            if lSide {
                self.position = CGPoint(x: -border.width/2 - self.frame.width*xScale, y: pos.y)
                self.physicsBody?.velocity.dx = 300*xScale
            }
            else {
                self.position = CGPoint(x: border.width/2 + self.frame.width*xScale, y: pos.y)
                self.physicsBody?.velocity.dx = -300*xScale
            }
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.collisionBitMask &= ~CollisionTypes.wall.rawValue
            self.physicsBody?.contactTestBitMask &= ~CollisionTypes.wall.rawValue
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3*Double(xScale)) {
                self.physicsBody?.affectedByGravity = true
                self.physicsBody?.collisionBitMask |= CollisionTypes.wall.rawValue
                self.physicsBody?.contactTestBitMask |= CollisionTypes.wall.rawValue
            }
        }
        
        
        sceneRef.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func Hit() {
        lives -= 1
        livesText.text = String(lives)
        
        if lives <= 0 {
            Destroy()
        }
    }
    
    private func Destroy() {
        if splitCount > 0 {
            
            // Calculate meteor lives
            while Int(Double(livesAtStart)*0.75) < sceneRef.gameDirector.minFirstMeteorHits {
                livesAtStart = Int(Double(livesAtStart) * 1.25)
            }
            let meteorLives = Int.random(in: sceneRef.gameDirector.minFirstMeteorHits...Int(Double(livesAtStart)*0.75))
            
            // Calculate meteor scale based on lives
            let scale = UtilFunctions.map(x: Float(meteorLives), in_min: Float(sceneRef.gameDirector.minMeteorHits), in_max: Float(sceneRef.gameDirector.maxMeteorHits), out_min: Float(sceneRef.gameDirector.minMeteorScale), out_max: Float(xScale))
            
            let meteor1 = Meteor(pos: position, scale: CGFloat(scale), col: .blue, totalLives: meteorLives, sceneRef: sceneRef, splitCount: self.splitCount-1)
            let meteor2 = Meteor(pos: position, scale: CGFloat(scale), col: .blue, totalLives: meteorLives, sceneRef: sceneRef, splitCount: self.splitCount-1)
            
            // Give impulse to the spawned meteors
            let xImp: CGFloat = 2500
            let yImp: CGFloat = 4000
            let vec1 = CGVector(dx: -xImp, dy: yImp)
            let vec2 = CGVector(dx: xImp, dy: yImp)
            meteor1.physicsBody?.applyImpulse(vec1)
            meteor2.physicsBody?.applyImpulse(vec2)
        }
        
        
        
        self.removeFromParent()
    }
}
