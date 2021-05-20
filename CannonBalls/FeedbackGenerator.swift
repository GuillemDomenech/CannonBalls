//
//  FeedbackGenerator.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 20/05/2021.
//

import Foundation
import SpriteKit

class FeedbackGenerator {
    var lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    var splitImpactGenerator = UIImpactFeedbackGenerator(style: .rigid)
    

    init() {
        
        splitImpactGenerator.prepare()
        lightImpactGenerator.prepare()
    }
    
    func playShootHaptic() {
        lightImpactGenerator.impactOccurred(intensity: 0.6)
    }
    
    func playSplitHaptic() {
        splitImpactGenerator.impactOccurred()
    }
    
    
}
