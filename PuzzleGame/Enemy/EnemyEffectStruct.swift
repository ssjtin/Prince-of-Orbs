//
//  EnemyEffectStruct.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 10/10/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import UIKit

enum EffectType: String {
    case elementAbsorb
    case strongAbsorb        //  Absorb attacks over amount
    case timeReduce
    case freeze               //  Freeze column
    
    var effectImage: UIImage? {
        return UIImage(named: "icon_" + self.rawValue)
    }
}

enum Side: String {
    case Left
    case Right
}

struct EnemyAttack: Decodable {
    let type: EffectType
    let value: Int?
    let element: Element?
    let side: Side?
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
        case element
        case side
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeString = try values.decode(String.self, forKey: .type)
        type = EffectType(rawValue: typeString)!
        value = try values.decodeIfPresent(Int.self, forKey: .value)
        if let elementNumber = try? values.decodeIfPresent(Int.self, forKey: .element) {
            element = Element(rawValue: elementNumber)
        } else {
            element = nil
        }
        if let sideString = try? values.decodeIfPresent(String.self, forKey: .side) {
            side = Side(rawValue: sideString)
        } else {
            side = nil
        }
    }
    
}
