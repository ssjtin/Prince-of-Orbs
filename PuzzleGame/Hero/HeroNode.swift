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
    var itemNode: ItemNode
    var coinLabel: SKLabelNode
    
    var coinCount = 0 {
        didSet {
            self.coinLabel.text = "$\(self.coinCount)"
        }
    }
    
    var items = [Item]() {
        didSet {
            itemNode.addItemSprites(items)
        }
    }

    override init() {
        heroSprite = SKSpriteNode(imageNamed: "bluetrainer")
        backgroundSprite = SKSpriteNode()
        backgroundSprite.color = .white
        coinLabel = SKLabelNode(text: "$0")
        itemNode = ItemNode(size: CGSize(width: 150, height: 50))
        
        super.init()
        
        backgroundSprite.size = CGSize(width: 390, height: 200)
        backgroundSprite.zPosition = 0
        
        heroSprite.size = CGSize(width: 100, height: 140)
        heroSprite.position = CGPoint(x: -130, y: 0)
        heroSprite.zPosition = 1
        
        itemNode.position = CGPoint(x: 20, y: 50)
        itemNode.zPosition = 1
        
        coinLabel.position = CGPoint(x: 150, y: 70)
        coinLabel.fontColor = .black
        
        addChild(heroSprite)
        addChild(backgroundSprite)
        addChild(itemNode)
        addChild(coinLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buy(item: Item) {
        items.append(item)
        coinCount -= item.cost
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let position = touch.location(in: self)
        let touchedNodes = self.nodes(at: position)
         
        if let item = touchedNodes.first(where: { ($0.name ?? "").contains("held_item") } ),
           let name = item.name,
           let char = name.last,
           let index = Int(String(char)) {
            items.remove(at: index)
        }
    }
    
}
