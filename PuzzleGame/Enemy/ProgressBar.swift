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
    
    var mainBar = SKSpriteNode(imageNamed: "progress_0")
    
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
        let percentage = CGFloat(currentScore) / CGFloat(targetScore) * 100
        switch percentage {
        case let x  where x < 5:
            mainBar.texture = SKTexture(imageNamed: "progress_0")
        case let x where x < 15:
            mainBar.texture = SKTexture(imageNamed: "progress_10")
        case let x where x < 25:
            mainBar.texture = SKTexture(imageNamed: "progress_20")
        case let x where x < 35:
            mainBar.texture = SKTexture(imageNamed: "progress_30")
        case let x where x < 45:
            mainBar.texture = SKTexture(imageNamed: "progress_40")
        case let x where x < 55:
            mainBar.texture = SKTexture(imageNamed: "progress_50")
        case let x where x < 75:
            mainBar.texture = SKTexture(imageNamed: "progress_70")
        case let x where x < 95:
            mainBar.texture = SKTexture(imageNamed: "progress_90")
        default:
            mainBar.texture = SKTexture(imageNamed: "progress_100")
        }
    }

}

