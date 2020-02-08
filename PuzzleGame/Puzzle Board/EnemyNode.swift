//
//  EnemyNode.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 2/2/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//
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

struct Enemy: Decodable {
    let id: String
    let imageName: String
    let attacks: [EnemyAttack]
    var health: Int {
        didSet {
            print(self.health)
        }
    }
    let counter: Int
}

import SpriteKit

class EnemyNode: SKNode {
    
    var backgroundSprite: SKSpriteNode
    var sprite: SKSpriteNode
    var attackIconNode: SKSpriteNode
    
    var enemy: Enemy
    var activeAttack: EnemyAttack? {
        didSet {
            if let image = self.activeAttack?.type.effectImage {
                attackIconNode.texture = SKTexture(image: image)
            } else {
                attackIconNode.texture = nil
            }
        }
    }
    var turnCounter: Int
    
    init(enemy: Enemy) {
        self.enemy = enemy
        
        sprite = SKSpriteNode(imageNamed: enemy.imageName)
        sprite.size = CGSize(width: 200, height: 200)
        
        backgroundSprite = SKSpriteNode(imageNamed: "aura")
        backgroundSprite.size = CGSize(width: 300, height: 300)
        
        attackIconNode = SKSpriteNode()
        attackIconNode.size = CGSize(width: 40, height: 40)
        
        sprite.zPosition = 1
        attackIconNode.zPosition = 1
        self.turnCounter = enemy.counter
        
        super.init()
        addChild(sprite)
        addChild(backgroundSprite)
        addChild(attackIconNode)
        
        attackIconNode.position = CGPoint(x: 0, y: -200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDamage(_ damage: Int) {
        enemy.health -= damage
    }
    
    func incrementAttack(completion: @escaping () -> Void) {
        self.activeAttack = nil
        if turnCounter == 1 {
            //  Will attack, reset counter
            turnCounter = enemy.counter
            //  Do any animation here
            activeAttack = enemy.attacks.randomElement()
            completion()
        } else {
            turnCounter -= 1
            completion()
        }
    }
    
}
