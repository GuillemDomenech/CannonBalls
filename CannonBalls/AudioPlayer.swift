//
//  AudioPlayer.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 19/05/2021.
//

import Foundation
import AVFoundation
import SpriteKit

class AudioPlayer {
    
    var gameScene: GameScene
    var shootSound: SKAction
    var hitSound: SKAction
    var splitSound: SKAction

    init(gameScene: GameScene) {
        shootSound = SKAction.playSoundFileNamed("shoot", waitForCompletion: false)
        hitSound = SKAction.playSoundFileNamed("hit", waitForCompletion: false)
        splitSound = SKAction.playSoundFileNamed("split", waitForCompletion: false)
        self.gameScene = gameScene
    }
    
    func playShootSound() {
        gameScene.run(shootSound)
    }
    
    func playHitSound() {
        gameScene.run(hitSound)
    }
    
    func playSplitSound() {
        gameScene.run(splitSound)        
    }
    
}
