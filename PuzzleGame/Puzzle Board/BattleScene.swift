//
//  GameScene.swift
//  TinsGame
//
//  Created by Hoang Luong on 21/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class BattleScene: SKScene {
    
    var level = Level()                //Level class controls puzzle orbs
    let gameSound = GameSound()         //Preload game sounds

    //Orb handling logic variables
    var swipedOrbs: [(column: Int, row: Int)] = [] {
        didSet {
            if self.swipedOrbs.count == 1 && isSwiping == false {
                handleMatches()
            }
        }
    }
    
    var isSwiping: Bool = false
    
    var activeOrb: SKSpriteNode?
    var initialOrb: SKSpriteNode?
    
    //Combo variables
    var comboCount: Int = 0
    var comboChains: [Chain] = []
    
    //Scene layers
    let gameLayer = SKNode()
    let moveTimer = MoveTimerNode(size: CGSize(width: 25, height: 150))
    
    override init(size: CGSize) {
        super.init(size: size)
        
        //Set scene anchorPoint to centre of screen
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
        
        setBackgroundImage()
        configureMainLayers()
        configureTimerBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    
    }
    
    private func setBackgroundImage() {
        let background = SKSpriteNode(imageNamed: "background")
        addChild(background)
    }
    
    private func configureMainLayers() {
        //Set origin point for orbs and tiles
        let layerPosition = CGPoint(
            x: -tileWidth*3,
            y: -(screenHeight / 2 - 10))
        //Add child layers to parents
        addChild(gameLayer)
        level.puzzleNode.position = layerPosition
        gameLayer.addChild(level.puzzleNode)
    }
    
    private func configureTimerBar() {
        moveTimer.delegate = self
        moveTimer.position = CGPoint(x: -screenWidth / 2 + 30, y: 0)
        gameLayer.addChild(moveTimer)
    }
    
    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * tileWidth + tileWidth / 2,
            y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    
    //Touches methods
    
    //Converts touch location to orb? or invalid
    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(numColumns) * tileWidth && point.y >= 0 && point.y < CGFloat(numRows) * tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        } else {
            return (false, 0, 0) // invalid location
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        swipedOrbs.removeAll()
        isSwiping = true
        
        let location = touch.location(in: level.orbsLayer)
        
        let (success, column, row) = convertPoint(location)
        
        if success {    //Initial touch successfully mapped to valid orb
            if let orb = level.orb(atColumn: column, row: row) {
                initialOrb = orb.sprite
                initialOrb?.alpha = 0
                swipedOrbs.append((column, row))
                activeOrb = SKSpriteNode(imageNamed: orb.element.spriteName)
                activeOrb?.size = CGSize(width: 65, height: 65)
                level.orbsLayer.addChild(activeOrb!)
                activeOrb?.position = location
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Escape if first touch was not a valid orb
        guard let orb = swipedOrbs.last else { return }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: level.orbsLayer)
        activeOrb?.position = location
        
        let (success, column, row) = convertPoint(location)
        if success {
            
            var horizontalDelta = 0, verticalDelta = 0
            if column+1 == orb.column {
                horizontalDelta = -1        // swiped left
            } else if column-1 == orb.column {
                horizontalDelta = 1         // swiped right
            } else if row+1 == orb.row {
                verticalDelta = -1          // swiped down
            } else if row-1 == orb.row {
                verticalDelta = 1           // swiped up
            }
            
            if horizontalDelta != 0 || verticalDelta != 0 {
                
                let toColumn = orb.column + horizontalDelta
                let toRow = orb.row + verticalDelta
                
                guard toColumn >= 0 && toColumn < numColumns else { return }
                guard toRow >= 0 && toRow < numRows else { return }
                
                swipedOrbs.append((toColumn, toRow))
                moveTimer.startTimer()
                
                if swipedOrbs.count == 2 {
                    trySwap()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endMove()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        endMove()
    }
    
    func endMove() {
        activeOrb?.removeFromParent()
        activeOrb = nil
        initialOrb?.alpha = 1
        initialOrb = nil
        isSwiping = false
        moveTimer.cancelTimer()
        if swipedOrbs.count == 1 {
            handleMatches()
        }
    }
    
    func trySwap() {

        if  let toOrb = level.orb(atColumn: swipedOrbs[1].column, row: swipedOrbs[1].row),
            let fromOrb = level.orb(atColumn: swipedOrbs[0].column, row: swipedOrbs[0].row) {
            
            let swap = Swap(orbA: fromOrb, orbB: toOrb)
            handleSwipe(swap)

        }
    }
    
    func startMoveTimer() {
        moveTimer.startTimer()
    }
    
    func handleSwipe(_ swap: Swap) {
        level.performSwap(swap)
        animate(swap) { [unowned self] in
            self.swipedOrbs.remove(at: 0)
            if self.swipedOrbs.count > 1 {
                self.trySwap()
            }
        }
    }
    
    func handleMatches() {
        
        func removeMatches(_ chains: Set<Chain>) {
            level.removeMatches(chains)
            animateMatchedOrbs(for: chains) {
                let columns = self.level.fillHoles()
                self.animateFallingOrbs(in: columns, completion: {
                    let columns = self.level.topUpOrbs()
                    self.animateNewOrbs(in: columns, completion: {
                        if let newChains = self.level.detectMatches() {
                            removeMatches(newChains)
                        } else {
                            self.resolveCombos()
                        }
                    })
                })
            }
        }
        
        if let chains = level.detectMatches() {
            removeMatches(chains)
        }
        
    }
    
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
                let sprite = SKSpriteNode(imageNamed: orb.element.spriteName)
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
    
    func resolveCombos() {
    }
    
    func endCurrentStage() {
        print("defeated enemy")
    }
    
}

extension BattleScene: TimerDelegate {
    
    func timerDidEnd() {
        if self.isSwiping == true {
            endMove()
        }
    }
    
}
