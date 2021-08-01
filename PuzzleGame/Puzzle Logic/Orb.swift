//
//  Orb.swift
//  TinsGame
//
//  Created by Hoang Luong on 22/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//


import SpriteKit

enum OrbType: Int, CaseIterable {
    case unknown = 0, Fire, Water, Grass, Light, Dark, Silver, Slime
    
    static var allCases: [OrbType] {
        return [.Fire, .Water, .Grass, .Light, .Dark, .Silver]
    }
    var spriteName: String {
        let spriteNames = [
            "red_orb",
            "blue_orb",
            "green_orb",
            "light_orb",
            "dark_orb",
            "silver_orb",
            "slime_orb"
        ]
        
        return spriteNames[rawValue - 1]
    }
    
    var matchValue: Float {
        switch self {
        case .Fire: return 0.99
        case .Water: return 2.0
        case .Grass: return 3.5
        case .Light: return 5.0
        case .Dark: return 5.5
        case .Silver: return 8.0
        default: return 0
        }
    }
    
    static func randomElement() -> OrbType {
        return OrbType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
    
}

class Orb: CustomStringConvertible, Hashable, Comparable {
    
    static func < (lhs: Orb, rhs: Orb) -> Bool {
        return lhs.row < rhs.row ||
        (lhs.row == rhs.row && lhs.column < rhs.column)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(column)
        hasher.combine(row)
    }
    
    static func ==(lhs: Orb, rhs: Orb) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    var description: String {
        return "type: \(element) square: (\(column), \(row))"
    }
    
    var column: Int
    var row: Int
    let element: OrbType
    var sprite: SKSpriteNode?
    
    var spriteName: String {
        return element.spriteName
    }
    
    init(column: Int, row: Int, element: OrbType) {
        self.column = column
        self.row = row
        self.element = element
    }
    
}
