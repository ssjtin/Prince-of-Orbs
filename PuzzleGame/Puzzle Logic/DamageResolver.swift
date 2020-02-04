//
//  DamageResolver.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 4/2/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

class DamageResolver {
    
    var baseStrength: Float = 5
    
    var prongCount: Float = 0
    
    var elementMultiplier = [Element: Float]()
    
    init() {
        for element in Element.allCases {
            elementMultiplier[element] = 1
        }
    }
    
    func calculateDamage(from chains: [Chain]) -> Int {
        
        var damage: Float = 0
        
        for chain in chains {
            damage += (1 + Float(chain.numExtraOrbs) * 0.2) * baseStrength
            chain.chainType == .TPA ? prongCount += 1 : ()
        }
        
        if prongCount > 0 {
            [1...prongCount].forEach { (_) in
                damage *= 1.2
            }
        }
        
        return Int(damage)
        
    }

}
