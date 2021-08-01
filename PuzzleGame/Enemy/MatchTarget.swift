//
//  MatchTarget.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 5/1/21.
//  Copyright © 2021 Hoang Luong. All rights reserved.
//

import Foundation

enum Obstruction {
    case timeReduction(amount: TimeInterval)
    case slime(number: Int)
}

/// Stage info including turns and targets of each orb type
struct StageInfo {
    
    let timebank: TimeInterval
    let targetValue: Float
    var currentValue: Float = 0.0
    
    var completed: Bool {
        return currentValue >= targetValue
    }
    
    mutating func update(with chains: [Chain], multiplier: Float) {
        var matchedValue: Float = 0.0
        chains.forEach { (chain) in
            matchedValue += chain.element.matchValue
        }
        currentValue += matchedValue
    }
}

extension Sequence where Element == Chain {
    
    /// Return total number of matched orbs of given type from a chain of matches
    func numMatchedOrbs(type: OrbType) -> Int {
        return (self.filter { $0.element == type }).map { $0.length }.reduce(0, +)
    }
    
}
