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

class GameScene: SKScene {
    
    var level = PuzzleBoard()                //Level class controls puzzle orbs
    let gameSound = GameSound()         //Preload game sounds
    
    var stageNode: StageNode!
    var stages = [Stage]()
    var currentStageIndex = 0

    //Orb handling logic variables
    var swipedOrbs: [(column: Int, row: Int)] = [] {
        didSet {
            if self.swipedOrbs.count == 1 && isSwiping == false {
                handleMatches()
            }
        }
    }
    
    var isSwiping: Bool = false
    var didActivateTurn: Bool = false
    
    var activeOrb: SKSpriteNode?
    var initialOrb: SKSpriteNode?
    
    //Combo variables
    var comboCount: Int = 0
    var comboChains: [Chain] = []
    
    var damageResolver = DamageResolver()
    
    //Scene layers
    let gameLayer = SKNode()
    let moveTimer = MoveTimerNode(size: CGSize(width: 200, height: 30))
    let heroNode = HeroNode()
    
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
    
    private func setBackgroundImage() {
        let background = SKSpriteNode()
        background.color = .white
        background.size = CGSize(width: screenWidth * 2, height: screenHeight)
        addChild(background)
    }
    
    private func configureMainLayers() {
        //Set origin point for orbs and tiles
        let layerPosition = CGPoint(
            x: -tileWidth*3,
            y: -screenHeight/4)//-(screenHeight / 2 - 10))
        //Add child layers to parents
        addChild(gameLayer)
        level.puzzleNode.position = layerPosition
        gameLayer.addChild(level.puzzleNode)
        
        //  Configure hero hud node
        heroNode.position = CGPoint(x: 0, y: -330)
        gameLayer.addChild(heroNode)
    }
    
    private func configureTimerBar() {
        moveTimer.delegate = self
        moveTimer.position = CGPoint(x: -100, y: 120)
        gameLayer.addChild(moveTimer)
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * tileWidth + tileWidth / 2,
            y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    
    func load(stages: [Stage]) {
        self.stages = stages
        load(stage: stages[currentStageIndex])
    }
    
    func load(stage: Stage) {
        stageNode = StageNode(stage: stage)
        addChild(stageNode)
        let yPosition = screenHeight / 2 - stageNode.sprite.size.height / 2 - 50
        stageNode.position = CGPoint(x: 0, y: yPosition)
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
                activeOrb = SKSpriteNode(imageNamed: orb.spriteName)
                activeOrb?.size = CGSize(width: 65, height: 65)
                level.orbsLayer.addChild(activeOrb!)
                activeOrb?.position = location
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isSwiping else { return }
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
                didActivateTurn = true
                
                if swipedOrbs.count == 2 {
                    trySwap()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSwiping {
            //  Check if item pressed
            endMove()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSwiping {
            endMove()
        }
    }
    
    func endMove() {
        activeOrb?.removeFromParent()
        activeOrb = nil
        initialOrb?.alpha = 1
        initialOrb = nil
        isSwiping = false
        if didActivateTurn {
            moveTimer.cancelTimer()
            isUserInteractionEnabled = false
            handleMatches()
        } else {
            if let column = swipedOrbs.first?.column,
               let row = swipedOrbs.first?.row,
               let orb = level.orb(atColumn: column, row: row) {
                if orb.element == .Item {
                    itemPressed(column: column, row: row)
                }
            }
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
    
    func itemPressed(column: Int, row: Int) {
        guard let pressedOrb = level.orb(atColumn: column, row: row), let item = pressedOrb.item else { return }
        
        if item.cost <= heroNode.coinCount {
            //  Can afford to buy item
            
            let alert = UIAlertController(title: "Buy Item?", message: "Would you like to buy item for \(item.cost) coins", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "Buy", style: .default) { (_) in
                self.heroNode.items.append(item)
                self.level.replaceOrb(at: column, row: row)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(acceptAction)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        } else {
            //  Can't afford to buy item
            let alert = UIAlertController(title: "Not enough coins", message: "Please collect more coins to buy this item.", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func handleMatches() {
        
        var matchedChains = [Chain]()
        
        //  Recursive function that removes matches, refills, and continues until no new matches
        
        func removeMatches(_ chains: Set<Chain>) {
            level.removeMatches(chains)
            animateMatchedOrbs(for: chains) {
                let columns = self.level.fillHoles()
                self.animateFallingOrbs(in: columns, completion: {
                    let columns = self.level.topUpOrbs(itemChance: 12)
                    self.animateNewOrbs(in: columns, completion: {
                        if let newChains = self.level.detectMatches() {
                            matchedChains.append(contentsOf: Array(chains))
                            removeMatches(newChains)
                        } else {
                            let coinChains = matchedChains.filter { $0.element == .Coin }.count
                            self.heroNode.coinCount += coinChains
                            let damage = self.damageResolver.calculateDamage(from: matchedChains)
                            self.resolveCombos(damage: damage)
                            self.didActivateTurn = false
                            self.didResolveTurn()
                        }
                    })
                })
            }
        }
        
        if let chains = level.detectMatches() {
            matchedChains.append(contentsOf: Array(chains))
            removeMatches(chains)
        } else if didActivateTurn {
            self.didActivateTurn = false
            self.didResolveTurn()
        } else {
            self.isUserInteractionEnabled = true
        }
        
    }
    
    private func didResolveTurn() {
        stageNode.incrementAttack {
            self.isUserInteractionEnabled = true
        }
    }

    func resolveCombos(damage: Int) {
        comboCount = 0
        let stageCompleted = stageNode.applyDamage(damage)
        if stageCompleted {
            currentStageIndex += 1
            stageNode.removeFromParent()
            load(stage: stages[currentStageIndex])
        }
    }

}

extension GameScene: TimerDelegate {
    
    func timerDidEnd() {
        if self.isSwiping == true {
            endMove()
        }
    }
    
}
