//
//  HeroNode.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 10/10/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SpriteKit

class HeroNode: SKNode {
    
    var heroSprite: SKSpriteNode
    var backgroundSprite: SKSpriteNode
    var itemSprite: SKSpriteNode
    var specialBar: SKSpriteNode
    var coinLabel: SKLabelNode

    override init() {
        heroSprite = SKSpriteNode(imageNamed: "bluetrainer")
        backgroundSprite = SKSpriteNode(imageNamed: "hud")
        itemSprite = SKSpriteNode(imageNamed: "items")
        specialBar = SKSpriteNode(imageNamed: "special_bar")
        coinLabel = SKLabelNode(text: "0 coins")
        
        super.init()
        
        backgroundSprite.size = CGSize(width: 390, height: 200)
        backgroundSprite.zPosition = 0
        
        heroSprite.size = CGSize(width: 100, height: 140)
        heroSprite.position = CGPoint(x: -130, y: 0)
        heroSprite.zPosition = 1
        
        itemSprite.size = CGSize(width: 150, height: 44)
        itemSprite.position = CGPoint(x: 20, y: 50)
        itemSprite.zPosition = 1
        
        specialBar.size = CGSize(width: 250, height: 80)
        specialBar.position = CGPoint(x: 50, y: -50)
        
        addChild(heroSprite)
        addChild(backgroundSprite)
        addChild(itemSprite)
        addChild(specialBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

