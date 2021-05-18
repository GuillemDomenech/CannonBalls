//
//  UtilFunctions.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 18/05/2021.
//

import Foundation

class UtilFunctions {
    public static func lerp (a: Float, b: Float, d: Float) -> Float {
        return a*(1-d)+b*d
    }
    
    public static func map(x: Float, in_min: Float, in_max: Float, out_min: Float, out_max: Float) -> Float {
      return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    }
}
