//
//  EnemyNode.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 2/2/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//
enum EffectType: String {
    case absorb
    case timeReduce
    case freeze
}

struct EnemyAttack: Decodable {
    let type: EffectType
    let value: Int?
    let element: Element?
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
        case element
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
    }
    
}

struct Enemy: Decodable {
    let id: String
    let imageName: String
    let attacks: [EnemyAttack]
    let health: Int
    let counter: Int
}

import SpriteKit

class EnemyNode: SKNode {
    
    var backgroundSprite: SKSpriteNode
    var sprite: SKSpriteNode
    
    init(enemy: Enemy) {
        sprite = SKSpriteNode(imageNamed: enemy.imageName)
        sprite.size = CGSize(width: 200, height: 200)
        backgroundSprite = SKSpriteNode(imageNamed: "aura")
        backgroundSprite.size = CGSize(width: 300, height: 300)
        sprite.zPosition = 1
        
        super.init()
        addChild(sprite)
        addChild(backgroundSprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
