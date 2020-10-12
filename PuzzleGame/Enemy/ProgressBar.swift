//
//  HealthBar.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 10/10/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SpriteKit

class ProgressBar: SKSpriteNode {
    
    var isActive: Bool = false
    
    var mainBar = SKSpriteNode(imageNamed: "bar_100")
    
    var length: CGFloat {
        self.size.width
    }
    
    let targetScore: Int
    var currentScore: Int
    
    var stageCompleted: Bool {
        return currentScore >= targetScore
    }
    
    weak var delegate: TimerDelegate?
    
    init(size: CGSize, targetScore: Int) {
        self.targetScore = targetScore
        self.currentScore = 0
        
        super.init(texture: nil, color: .clear, size: size)
        
        mainBar.size = CGSize(width: length, height: size.height)
        mainBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        mainBar.zPosition = 10
        mainBar.position = CGPoint(x: -size.width/2, y: 0)
        
        addChild(mainBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustScore(by amount: Int) {
        self.currentScore = max(min(targetScore, currentScore + amount), 0)
        let proportion = CGFloat(currentScore) / CGFloat(targetScore)
    }

}

