//
//  MatchTarget.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 5/1/21.
//  Copyright © 2021 Hoang Luong. All rights reserved.
//

import Foundation

/// Keep track of target count for specific orb type and number matched so far
struct OrbTarget {
    let element: OrbType
    let targetCount: Int
    var matchedCount: Int = 0
    
    var success: Bool {
        return matchedCount >= targetCount
    }
    
    var remainingCount: Int {
        return max(targetCount - matchedCount, 0)
    }
    
    mutating func add(_ numOrbs: Int) {
        matchedCount = min(matchedCount + numOrbs, targetCount)
    }
}

enum Obstruction {
    case timeReduction(amount: TimeInterval)
    case slime(number: Int)
}

/// Stage info including turns and targets of each orb type
struct StageInfo {
    
    var turns: Int
    var orbTargets: [OrbTarget]
    
    var completed: Bool {
        return orbTargets.filter { $0.success == false }.count == 0
    }
    
    var outOfTurns: Bool {
        return !(turns > 0)
    }
    
    
    
    mutating func update(with chains: [Chain], multiplier: Float) {
        for index in 0..<orbTargets.count {
            orbTargets[index].add(Int(Float(chains.numMatchedOrbs(type: orbTargets[index].element)) * multiplier))
        }
        turns -= 1
    }
}

extension Sequence where Element == Chain {
    
    /// Return total number of matched orbs of given type from a chain of matches
    func numMatchedOrbs(type: OrbType) -> Int {
        return (self.filter { $0.element == type }).map { $0.length }.reduce(0, +)
    }
    
    var numOfclocksMatched: Int {
        return self.filter { $0.element == .Time }.count
    }
    
}
