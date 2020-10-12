//
//  ItemStruct.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 11/10/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

enum ItemEffect {
    case delay
    case gravity
    case attackBoost
    case timeExtend
}

struct Item {
    let effect: ItemEffect
    let cost: Int
    let effectValue: Int
    let imageName: String
    
    static func random() -> Item {
        return Item(effect: .delay, cost: 2, effectValue: 3, imageName: "delay_2")
    }
}
