//
//  GameDirector.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 18/05/2021.
//

import Foundation
import SwiftUI

class GameDirector {
    
    private var lastMeteorSpawnTime: Double = 0.0
    private var meteorSpawningDelay: Double = 10 // Spawn every X seconds
    
    private var currentFrameTime: Double = 0.0
    private var matchStartTime: Double = 0.0
    
    private var difficultyLevel: Int = 0
    
    public var maxMeteorHits: Int = 30      // Meteorito padre entre 30 y 5, hijos entre rand(30-5) y 2
    public var minFirstMeteorHits: Int = 4
    public var minMeteorHits: Int = 2
    
    public var maxMeteorScale: Float = 0.9
    public var minMeteorScale: Float = 0.45
    
    private var currentMaxSplitCount: Int = 1
    private var currentMinSplitCount: Int = 0
    
    
    
    let sceneRef: GameScene
    
    init(_sceneRef:GameScene) {
        self.sceneRef = _sceneRef
    }
    
    func resetInternalTimer() {
        matchStartTime = currentFrameTime
    }
    
    
    public func update(currentTime: TimeInterval) {
        currentFrameTime = currentTime
        
        if matchStartTime == 0 {
            resetInternalTimer()
            return
        }
        
        handleMeteorSpawning()
        handleIncreaseDifficulty()
    }
    
    func handleMeteorSpawning() {
        if((currentFrameTime - lastMeteorSpawnTime) > meteorSpawningDelay) {
            SpawnMeteor()
            lastMeteorSpawnTime = currentFrameTime
        }
    }
    
    func SpawnMeteor() {
        let bounds = sceneRef.getThisVisibleScreen()
        
        let randPosX = CGFloat(Int.random(in: -1..<1)) // Choose which side to spawn the meteor, 50% chance
        
        // Calculate meteor lives
        let meteorLives = Int.random(in: minFirstMeteorHits...maxMeteorHits)
        
        // Calculate meteor scale based on lives
        let scale = UtilFunctions.map(x: Float(meteorLives), in_min: Float(minMeteorHits), in_max: Float(maxMeteorHits), out_min: Float(minMeteorScale), out_max: Float(maxMeteorScale))
        
        // Calculate split count
        let splitCount = Int.random(in: currentMinSplitCount...currentMaxSplitCount)
        
        let _ = Meteor(pos: CGPoint(x: randPosX, y: bounds.maxY*0.8), scale: CGFloat(scale), col: .red, totalLives: meteorLives,  sceneRef: sceneRef, sideSpawn: true, splitCount: splitCount)
    }
    
    func handleIncreaseDifficulty() {
        let secondsSinceMatchStart = currentFrameTime - matchStartTime
//        print("sec \(secondsSinceMatchStart)")
        
        if difficultyLevel < 1 && secondsSinceMatchStart > 20.0 {
            changeDifficulty(newDiff: 1)
        }
        if difficultyLevel < 2 && secondsSinceMatchStart > 40.0 {
            changeDifficulty(newDiff: 2)
        }
        if difficultyLevel < 3 && secondsSinceMatchStart > 60.0 {
            changeDifficulty(newDiff: 3)
        }
    }
    
    func changeDifficulty(newDiff: Int) {
        difficultyLevel = newDiff
        print("Incresing difficulty \(newDiff)")
        if newDiff == 1 {
            minFirstMeteorHits = 6
            currentMaxSplitCount = 2
            sceneRef.shootingFrecuency *= 1.5
        }
        if newDiff == 2 {
            meteorSpawningDelay = 7
            sceneRef.shootingFrecuency *= 1.25
        }
        if newDiff == 3 {
            meteorSpawningDelay = 6
            maxMeteorHits = 35
            currentMaxSplitCount = 3
            sceneRef.shootingFrecuency *= 2
        }
    }
}
