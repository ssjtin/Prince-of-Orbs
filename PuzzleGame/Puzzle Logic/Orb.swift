//
//  Orb.swift
//  TinsGame
//
//  Created by Hoang Luong on 22/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

/*
    Item chance: 0...100 represents percentage chance a falling orb is an item.
 */


import SpriteKit

enum Element: Int, CaseIterable {
    case unknown = 0, Fire, Water, Grass, Light, Dark, Coin, Item
    
    static var allCases: [Element] {
        return [.unknown, .Fire, .Water, .Grass, .Light, .Dark, .Coin, .Item]
    }
    var spriteName: String {
        let spriteNames = [
            "red_orb",
            "blue_orb",
            "green_orb",
            "light_orb",
            "dark_orb",
            "coin_orb",
            "item_orb"
        ]
        
        return spriteNames[rawValue - 1]
    }
    
    static func randomElement(itemChance: Int = 0) -> Element {
        
        if Int(arc4random_uniform(99)) < itemChance {
            return Element.Item
        }
        
        return Element(rawValue: Int(arc4random_uniform(6)) + 1)!
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
    let element: Element
    var sprite: SKSpriteNode?
    var item: Item?
    
    var spriteName: String {
        if let item = item {
            return item.imageName
        } else {
            return element.spriteName
        }
    }
    
    init(column: Int, row: Int, element: Element) {
        self.column = column
        self.row = row
        self.element = element
        
        if element == .Item {
            self.item = Item.random()
        }
    }
    
}
