//
//  ItemNode.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 12/10/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SpriteKit

class ItemNode: SKSpriteNode {
    
    var itemLimit: Int = 3
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(size: CGSize) {
        self.init(texture: SKTexture(imageNamed: "itembelt"), color: UIColor.white, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addItemSprites(_ items: [Item]) {
        removeAllChildren()
        for (index, item) in items.enumerated() {
            let itemSprite = SKSpriteNode(imageNamed: item.imageName)
            let width = self.frame.width / 3
            itemSprite.size = CGSize(width: width, height: width)
            itemSprite.position = CGPoint(x: (index - 1) * Int(width), y: 0)
            itemSprite.name = "held_item_\(index)"
            addChild(itemSprite)
        }
    }
}
