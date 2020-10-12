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
    
    var coinCount = 5 {
        didSet {
            self.coinLabel.text = "\(self.coinCount) coins"
        }
    }
    
    var items = [Item]()

    override init() {
        heroSprite = SKSpriteNode(imageNamed: "bluetrainer")
        backgroundSprite = SKSpriteNode()
        backgroundSprite.color = .white
        itemSprite = SKSpriteNode(imageNamed: "itembelt")
        specialBar = SKSpriteNode(imageNamed: "special_bar")
        coinLabel = SKLabelNode(text: "5 coins")
        
        super.init()
        
        backgroundSprite.size = CGSize(width: 390, height: 200)
        backgroundSprite.zPosition = 0
        
        heroSprite.size = CGSize(width: 100, height: 140)
        heroSprite.position = CGPoint(x: -130, y: 0)
        heroSprite.zPosition = 1
        
        itemSprite.size = CGSize(width: 180, height: 60)
        itemSprite.position = CGPoint(x: 20, y: 50)
        itemSprite.zPosition = 1
        
        specialBar.size = CGSize(width: 250, height: 80)
        specialBar.position = CGPoint(x: 50, y: -50)
        
        coinLabel.position = CGPoint(x: 150, y: 70)
        coinLabel.fontColor = .black
        
        addChild(heroSprite)
        addChild(backgroundSprite)
        addChild(itemSprite)
        addChild(specialBar)
        addChild(coinLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
