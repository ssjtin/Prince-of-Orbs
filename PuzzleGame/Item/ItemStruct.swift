//
//  ItemStruct.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 11/10/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

enum ItemEffect: String {
    case delay
    case gravity
    case attackBoost
    case timeExtend
}

enum ItemType: String {
    case oneTime
    case permanent
}

struct Item {
    let type: ItemType
    let effect: ItemEffect
    let cost: Int
    let effectValue: Float
    let imageName: String
    
    var description: String {
        return type.rawValue + " " + effect.rawValue + " Cost = \(cost)" + " Value = \(effectValue)"
    }
    
    static func getTestItems() -> [Item] {
        var items = [Item]()
        items.append(Item(type: .oneTime, effect: .delay, cost: 5, effectValue: 1, imageName: ""))
        items.append(Item(type: .permanent, effect: .timeExtend, cost: 10, effectValue: 1.5, imageName: ""))
        items.append(Item(type: .permanent, effect: .attackBoost, cost: 8, effectValue: 0.5, imageName: ""))
        return items
    }
}


