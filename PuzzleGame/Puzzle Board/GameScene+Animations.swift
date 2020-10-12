//
//  GameScene+Animations.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 12/10/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

extension GameScene {
    
    //Mark: ANIMATIONS
    
    func animate(_ swap: Swap, completion: @escaping () -> Void) {
        let spriteA = swap.orbA.sprite!
        let spriteB = swap.orbB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let duration: TimeInterval = 0.01
        
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
        spriteA.run(moveA, completion: completion)
        
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut
        spriteB.run(moveB)
        
        run(gameSound.orbMovementSound)
    }
    
    func animateMatchedOrbs(for chains: Set<Chain>, completion: @escaping () -> ()) {
        let sorted = (Array(chains)).sorted()
        
        let duration: TimeInterval = 0.3
        
        for (index, chain) in sorted.enumerated() {
            
            let waitForSoundAction = SKAction.wait(forDuration: duration * Double(index))
            comboCount += 1
            comboChains.append(contentsOf: chains)
            let soundAction = chain.orbs.count == 4 ? gameSound.TPASound : gameSound.comboSound(for: comboCount)
            run(SKAction.sequence([waitForSoundAction, soundAction]))
            
            for orb in chain.orbs {
                if let sprite = orb.sprite {
                    if sprite.action(forKey: "removing") == nil {
                        //Shrink orbs in chain
                        let scaleAction = SKAction.scale(to: 0.1, duration: duration)
                        scaleAction.timingMode = .easeOut
                        //Wait according to combo sequence before starting animation
                        let waitAction = SKAction.wait(forDuration: duration * Double(index))
                        sprite.run(SKAction.sequence([waitAction, scaleAction, SKAction.removeFromParent()]), withKey: "removing")
                    }
                }
            }
        }
        run(SKAction.wait(forDuration: duration * Double(sorted.count)), completion: completion)
    }
    
    func animateFallingOrbs(in columns: [[Orb]], completion: @escaping () -> ()) {
        var longestDuration: TimeInterval = 0
        let delay = TimeInterval(0.5)
        for array in columns {
            for (_, orb) in array.enumerated() {
                let newPosition = pointFor(column: orb.column, row: orb.row)
                
                let sprite = orb.sprite!
                let duration = TimeInterval(((sprite.position.y - newPosition.y) / tileHeight) * 0.1)
                longestDuration = duration
                
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay),
                        SKAction.group([moveAction])]))
            }
        }
        run(SKAction.wait(forDuration: delay+longestDuration), completion: completion)
    }
    
    func animateNewOrbs(in columns: [[Orb]], completion: @escaping () -> Void) {
        // 1
        var longestDuration: TimeInterval = 0
        
        for array in columns {
            // 2
            let startRow = array[0].row + 1
            
            for (index, orb) in array.enumerated() {
                // 3
                let sprite = SKSpriteNode(imageNamed: orb.spriteName)
                sprite.size = CGSize(width: tileWidth, height: tileHeight)
                sprite.position = pointFor(column: orb.column, row: startRow)
                level.orbsLayer.addChild(sprite)
                orb.sprite = sprite
                // 4
                let delay = 0.1 + 0.2 * TimeInterval(array.count - index - 1)
                // 5
                let duration = TimeInterval(startRow - orb.row) * 0.1
                longestDuration = max(longestDuration, duration + delay)
                // 6
                let newPosition = pointFor(column: orb.column, row: orb.row)
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.alpha = 0
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay),
                        SKAction.group([
                            SKAction.fadeIn(withDuration: 0.05),
                            moveAction,])
                        ]))
            }
        }
        // 7
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
}
