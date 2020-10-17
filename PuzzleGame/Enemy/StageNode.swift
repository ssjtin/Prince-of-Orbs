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
    
    var attackLabel = SKLabelNode(text: "")
    var effectIconSprite = SKSpriteNode()
    
    var effectCaption = SKLabelNode(text: "")
    
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
        
        attackLabel.fontColor = .black
        attackLabel.position = CGPoint(x: 0, y: 90)
        attackLabel.alpha = 0
        
        //  Init countdown label
        countdownLabel = SKLabelNode(text: "\(stage.counter)")
        countdownLabel.position = CGPoint(x: 160, y: 80)
        countdownLabel.fontColor = .black
        
        //  Init enemy health bar
        progressBar = ProgressBar(size: CGSize(width: 300, height: 50), targetScore: stage.targetScore)
        progressBar.zPosition = 1
        progressBar.position = CGPoint(x: 0, y: -120)
        
        effectIconSprite.position = CGPoint(x: -175, y: 0)
        effectIconSprite.size = CGSize(width: 50, height: 50)
        
        effectCaption.fontColor = .black
        effectCaption.color = .blue
        
        sprite.zPosition = 1
        attackIconNode.zPosition = 1
        countdownLabel.zPosition = 1
        
        self.turnCounter = stage.counter
        
        super.init()
        addChild(progressBar)
        addChild(countdownLabel)
        addChild(sprite)
        addChild(attackIconNode)
        addChild(attackLabel)
        addChild(effectIconSprite)
        addChild(effectCaption)
        
        attackIconNode.position = CGPoint(x: 0, y: -200)
        effectCaption.numberOfLines = 0
        effectCaption.preferredMaxLayoutWidth = 300
        effectCaption.zPosition = 5
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
        
        turnCounter -= 1
        
        if turnCounter == 0 {
            //  Dead
            print("dead")
            completion()
            return
        }
        
        for attack in stage.attacks {
            let randomNum = arc4random_uniform(99)
            if randomNum <= attack.chance {
                self.activeAttack = attack
                print(attack.description)
                break
            }
        }
        
        if self.activeAttack != nil {
            handleEnemyAttack() {
                completion()
            }
        } else {
            completion()
        }
    }
    
    /*
        Instant effect attacks resolve right away, i.e. turn some blocks into jammers, then removed from self.attackAttack
        Turn effects stay around and affect players next turn, i.e. comboAbsorb
     */
    func handleEnemyAttack(completion: @escaping () -> Void) {
        guard let attack = activeAttack else { return }
        //  Animate attack effect
        switch attack.type {
        case .comboAbsorb:
            animate(attack: attack, completion: completion)
        default: ()
        }
    }
    
    func animate(attack: EnemyAttack, completion: @escaping () -> Void) {
        attackLabel.text = attack.description
        attackLabel.alpha = 1.0
        let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
        attackLabel.run(fadeOutAction) {
            if let iconName = attack.iconName {
                self.effectIconSprite.texture = SKTexture(imageNamed: iconName)
                self.effectIconSprite.name = "effect_absorb"
            }
            completion()
        }
    }
    
    //  Touches methods
    
    var isShowingEffectCaption = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let position = touch.location(in: self)
        let touchedNodes = self.nodes(at: position)
         
        if let item = touchedNodes.first(where: { ($0.name ?? "").contains("effect") } ),
           let name = item.name {
            switch name {
            case "effect_absorb":
                effectCaption.text = "Absorb damage from less than 3 chain combos."
            default: ()
            }
            
            isShowingEffectCaption = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isShowingEffectCaption {
            effectCaption.text = ""
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isShowingEffectCaption {
            effectCaption.text = ""
        }
    }
    
}
