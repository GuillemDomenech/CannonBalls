//
//  UtilFunctions.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 18/05/2021.
//

import Foundation
import UIKit
import SpriteKit

class UtilFunctions {
    public static func lerp (a: Float, b: Float, d: Float) -> Float {
        return a*(1-d)+b*d
    }
    
    public static func map(x: Float, in_min: Float, in_max: Float, out_min: Float, out_max: Float) -> Float {
      return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    }
    
    public static func getRandomColor() -> SKColor {
        return SKColor(hue: CGFloat(arc4random_uniform(255))/255.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    public static func transitionView(_ view: UIView?, show: Bool, duration: Double = 0.4, completion: ((Bool) -> Void)? = nil) {
        guard let view = view, view.isHidden == show, let parent = view.superview else {
            return
        }
        
        let target: UIView = show ? view : parent
        UIView.transition(with: target, duration: duration, options: [.transitionCrossDissolve], animations: {
            view.isHidden = !show
        }, completion: completion)
    }
}
