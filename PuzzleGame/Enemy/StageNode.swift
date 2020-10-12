//
//  EnemyNode.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 2/2/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

/*
        Includes the enemy sprite, health bar, attack and countdown visual elements
 */

import SpriteKit

class StageNode: SKNode {
    
    var sprite: SKSpriteNode
    var attackIconNode: SKSpriteNode
    var countdownLabel: SKLabelNode
    var progressBar: ProgressBar
    
    var stage: Stage
    var activeAttack: EnemyAttack?
    
    var turnCounter: Int {
        didSet {
            countdownLabel.text = "\(self.turnCounter)"
        }
    }
    
    init(stage: Stage) {
        self.stage = stage
        
        sprite = SKSpriteNode(imageNamed: stage.imageName)
        sprite.size = CGSize(width: 275, height: 200)
        
        attackIconNode = SKSpriteNode()
        attackIconNode.size = CGSize(width: 40, height: 40)
        
        //  Init countdown label
        countdownLabel = SKLabelNode(text: "\(stage.counter)")
        countdownLabel.position = CGPoint(x: 160, y: 80)
        countdownLabel.fontColor = .black
        
        //  Init enemy health bar
        progressBar = ProgressBar(size: CGSize(width: 300, height: 50), targetScore: stage.targetScore)
        progressBar.zPosition = 1
        progressBar.position = CGPoint(x: 0, y: -120)
        
        sprite.zPosition = 1
        attackIconNode.zPosition = 1
        countdownLabel.zPosition = 1
        
        self.turnCounter = stage.counter
        
        super.init()
        addChild(progressBar)
        addChild(countdownLabel)
        addChild(sprite)
        addChild(attackIconNode)
        
        attackIconNode.position = CGPoint(x: 0, y: -200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyDamage(_ damage: Int) -> Bool {
        progressBar.adjustScore(by: damage)
        return progressBar.currentScore >= progressBar.targetScore
    }
    
    func incrementAttack(completion: @escaping () -> Void) {
        self.activeAttack = nil
        if turnCounter == 1 {
            //  Will attack, reset counter
            turnCounter = stage.counter
            //  Do any animation here
            activeAttack = stage.attacks.randomElement()
            completion()
        } else {
            turnCounter -= 1
            completion()
        }
    }
    
}
