//
//  ItemNode.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 12/10/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SpriteKit

class ItemNode: SKSpriteNode {
    
    var itemBelt = SKSpriteNode(imageNamed: "itembelt")
    
    override init() {
        
        super.init()
        
        addChild(itemBelt)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
