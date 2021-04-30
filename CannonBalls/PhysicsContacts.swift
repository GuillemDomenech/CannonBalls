//
//  PhysicsContacts.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 30/04/2021.
//

import SpriteKit
import GameplayKit

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        guard let nameA = nodeA.name, let nameB = nodeB.name else { return }
        
        let oneNodeIsPlayer = nameA.hasPrefix("Player") || nameB.hasPrefix("Player")
        let oneNodeIsWall = nameA == "Wall" || nameB == "Wall"
        let oneNodeIsMeteor = nameA == "Meteor" || nameB == "Meteor"
        let oneNodeIsGround = nameA.hasPrefix("Ground") || nameB.hasPrefix("Ground")
        let oneNodeIsMissile = nameA.hasPrefix("Missile") || nameB.hasPrefix("Missile")
        let oneNodeIsCeiling = nameA.hasPrefix("Ceiling") || nameB.hasPrefix("Ceiling")
        
        if oneNodeIsGround && oneNodeIsMeteor/* || oneNodeIsPlayer && oneNodeIsMeteor*/ {
            let node = nodeA.name == "Meteor" ? nodeA : nodeB
            let lowerBound = 1400
            let upperBound = 1800
            let rndVelY = lowerBound + Int(arc4random()) % (upperBound - lowerBound);
            node.physicsBody!.velocity = CGVector(dx: nodeB.physicsBody!.velocity.dx, dy: CGFloat(rndVelY))
        }
        
        if oneNodeIsWall && oneNodeIsMeteor {
            let node = nodeA.name == "Meteor" ? nodeA : nodeB
            let multiplier: CGFloat = node.position.x > 0 ? -1 : 1
            //node.physicsBody?.applyImpulse(CGVector(dx: 1200.0*multiplier, dy:0.0))
            node.physicsBody!.velocity = CGVector(dx: 300.0*multiplier, dy: node.physicsBody!.velocity.dy)
            //node.physicsBody?.applyTorque(-333800.0*multiplier)
            node.physicsBody?.applyAngularImpulse(-15.0*multiplier)
        }
        
        if oneNodeIsMissile && oneNodeIsMeteor {
            let missileNode = nodeA.name == "Missile" ? nodeA : nodeB
            let meteorNode = (nodeA.name == "Meteor" ? nodeA : nodeB) as! Meteor
            missileNode.removeFromParent()
            meteorNode.Hit()
        }
        
        if oneNodeIsCeiling && oneNodeIsMissile {
            let missileNode = nodeA.name == "Missile" ? nodeA : nodeB
            missileNode.removeFromParent()
        }
        
        if oneNodeIsPlayer && oneNodeIsMeteor {
            // Game Over
            print("Game Over")
        }
        
        
    }
    
}
