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
    var looseSound: SKAction

    init(gameScene: GameScene) {
        shootSound = SKAction.playSoundFileNamed("shoot.mp3", waitForCompletion: false)
        hitSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
        splitSound = SKAction.playSoundFileNamed("split.mp3", waitForCompletion: false)
        looseSound = SKAction.playSoundFileNamed("loose.mp3", waitForCompletion: false)
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
    
    func playLooseSound() {
        gameScene.run(looseSound)
    }
}
