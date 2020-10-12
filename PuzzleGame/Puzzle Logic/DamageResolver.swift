//
//  DamageResolver.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 4/2/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

class DamageResolver {
    
    var attackMultiplier: Float = 1.0
    
    var prongCount: Float = 0
    
    var elementMultiplier = [Element: Float]()
    
    init() {
        for element in Element.allCases {
            elementMultiplier[element] = 1
        }
    }
    
    func calculateDamage(from chains: [Chain]) -> Int {
        
        var damage: Float = 0
        
        var turnMultiplier = attackMultiplier
        
        for chain in chains {
            damage += (1 + Float(chain.numExtraOrbs) * 0.2)
            chain.chainType == .TPA ? prongCount += 1 : ()
        }
        
        turnMultiplier += prongCount * 0.25
        turnMultiplier += Float(chains.count) * 0.10
        
        damage *= turnMultiplier
        
        //  Reset prongCount
        prongCount = 0
        
        return Int(damage)
    }

}
