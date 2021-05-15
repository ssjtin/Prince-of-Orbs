//
//  Chain.swift
//  TinsGame
//
//  Created by Hoang Luong on 23/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

enum ChainType {
    case TPA
    case Row
    case Column
    case Cross
    case Normal
}

enum MatchDirection {
    case horizontal
    case vertical
}

class Chain: Comparable, Hashable, CustomStringConvertible {
    
    static func ==(lhs: Chain, rhs: Chain) -> Bool {
        return lhs.orbs == rhs.orbs
    }
    
    static func < (lhs: Chain, rhs: Chain) -> Bool {
        return lhs.orbs.sorted().first! < rhs.orbs.sorted().first!
    }
    
    func hash(into hasher: inout Hasher) {
        for orb in orbs {
            hasher.combine(orb)
        }
    }
    
    var description: String {
        return "type:\(chainType) orbs:\(orbs)"
    }
    
    var orbs: [Orb] = []
    
    var direction: MatchDirection?
  
    var chainType: ChainType {
        
        if isCross {
            return .Cross
        }
        if orbs.count == 4 {
            return .TPA
        }
        if direction == .horizontal && length == 6 {
            return .Row
        }
        if direction == .vertical && length == 5 {
            return .Column
        }
        return .Normal
    }
    
    var isCross: Bool = false
    
    var centreOrb: Orb? {
        if length == 3 {
            return orbs.sorted()[1]
        }
        return nil
    }
    
    func add(orb: Orb) {
        orbs.append(orb)
    }
    
    var length: Int {
        return orbs.count
    }
    
    var numExtraOrbs: Int {
        return orbs.count - 3
    }
    
    var element: OrbType {
        if let first = orbs.first {
            return first.element
        }
        
        return .unknown
    }

    func combineIfNecessary(with chain: Chain) -> (Bool) {
        var sharesCommonOrb = false
        
        chain.orbs.forEach({ (orb) in
            if self.orbs.contains(orb) {
                //  Share a common orb
                if let firstCenter = centreOrb, let secondCenter = chain.centreOrb, firstCenter == secondCenter {
                    self.isCross = true
                }
                self.orbs = Array(Set(self.orbs + chain.orbs))
                self.direction = nil

                sharesCommonOrb = true
            }
        })
        return sharesCommonOrb
    }

}
