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
    
    var mainBar = SKSpriteNode()
    var backgroundBar = SKSpriteNode()
    var progressLabel = SKLabelNode()
    
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
        
        backgroundBar.color = .black
        backgroundBar.size = CGSize(width: length + 8, height: size.height+6)
        backgroundBar.position = CGPoint(x: 0, y: 0)
        
        mainBar.color = .blue
        mainBar.size = CGSize(width: 1, height: size.height-3)
        mainBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        mainBar.zPosition = 10
        mainBar.position = CGPoint(x: -size.width/2, y: 0)
        
        progressLabel.text = "0%"
        progressLabel.position = CGPoint(x: size.width/2 + 30, y: -progressLabel.frame.size.height/2)
        
        addChild(mainBar)
        addChild(backgroundBar)
        addChild(progressLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustScore(by amount: Int) {
        self.currentScore = max(min(targetScore, currentScore + amount), 0)
        let proportion = CGFloat(currentScore) / CGFloat(targetScore)
        let remainingBarWidth = length * proportion
        
        progressLabel.text = "\(Int(proportion * 100))%"
        mainBar.scale(to: CGSize(width: remainingBarWidth, height: size.height-3))
    }

}

