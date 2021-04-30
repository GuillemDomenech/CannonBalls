//
//  CollisionTypes.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 29/04/2021.
//

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case ground = 4
    case missile = 8
    case meteor = 16
    case ceiling = 32
}
