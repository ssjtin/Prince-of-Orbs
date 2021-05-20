//
//  GameScene.swift
//  TinsGame
//
//  Created by Hoang Luong on 21/7/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

/*
 
 Scene for the puzzle board and orbs.  Handle all the touches methods, moving orbs, resolving matches.
 
 */

import SpriteKit
import GameplayKit
import AVFoundation

protocol PuzzleBoardDelegate: class {
    func completedTurn(with matches: [Chain])
}

class PuzzleBoardScene: SKScene {
    
    weak var puzzleDelegate: PuzzleBoardDelegate?
    
    var puzzleBoard = PuzzleBoard()
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
    var didActivateTurn: Bool = false
    
    var activeOrb: SKSpriteNode?
    var initialOrb: SKSpriteNode?
    
    //  Combo variables
    var comboCount: Int = 0
    var comboChains: [Chain] = []

    //  Scene layers
    let gameLayer = SKNode()
    let moveTimer = MoveTimerNode(size: CGSize(width: 200, height: 30))
    
    override init(size: CGSize) {
        super.init(size: size)
        //Set scene anchorPoint to centre of screen
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
        
        configureMainLayers()
        configureTimerBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMainLayers() {
        //Add child layers to parents
        addChild(gameLayer)
        gameLayer.addChild(puzzleBoard.puzzleNode)
        gameLayer.position = CGPoint(x: -180, y: -180)
    }
    
    private func configureTimerBar() {
        addChild(moveTimer)
        moveTimer.delegate = self
        moveTimer.position = CGPoint(x: 0, y: 150)
        moveTimer.zPosition = 10
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
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
    
    var lastCoordinate: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        swipedOrbs.removeAll()
        isSwiping = true
        
        let location = touch.location(in: puzzleBoard.orbsLayer)
        
        let (success, column, row) = convertPoint(location)
        
        if success {    //Initial touch successfully mapped to valid orb
            if let orb = puzzleBoard.orb(atColumn: column, row: row) {
                initialOrb = orb.sprite
                initialOrb?.alpha = 0
                swipedOrbs.append((column, row))
                activeOrb = SKSpriteNode(imageNamed: orb.spriteName)
                activeOrb?.size = CGSize(width: 65, height: 65)
                puzzleBoard.orbsLayer.addChild(activeOrb!)
                activeOrb?.position = location
                lastCoordinate = location
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard isSwiping else { return }
        
        //Escape if first touch was not a valid orb
        guard let orb = swipedOrbs.last else { return }
        guard let touch = touches.first else { return }
        guard let lastTouch = lastCoordinate else { return }
        
        let location = touch.location(in: puzzleBoard.orbsLayer)
        
        guard abs(location.x - lastTouch.x) > 3 || abs(location.y - lastTouch.y) > 3 else { return }
        
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
        lastCoordinate = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isSwiping {
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
        lastCoordinate = nil
        if didActivateTurn {
            moveTimer.cancelTimer()
            isUserInteractionEnabled = false
            handleMatches()
        }
    }
    
    func trySwap() {
        if  let toOrb = puzzleBoard.orb(atColumn: swipedOrbs[1].column, row: swipedOrbs[1].row),
            let fromOrb = puzzleBoard.orb(atColumn: swipedOrbs[0].column, row: swipedOrbs[0].row) {
            
            let swap = Swap(orbA: fromOrb, orbB: toOrb)
            handleSwipe(swap)
        }
    }
    
    func startMoveTimer() {
        moveTimer.startTimer()
    }
    
    func handleSwipe(_ swap: Swap) {
        puzzleBoard.performSwap(swap)
        animate(swap) { [unowned self] in
            self.swipedOrbs.remove(at: 0)
            if self.swipedOrbs.count > 1 {
                self.trySwap()
            }
        }
    }
    
    func handleMatches() {
        //  Recursive function that removes matches, refills, and continues until no new matches
        func removeMatches(_ chains: Set<Chain>) {
            puzzleBoard.removeMatches(chains)
            animateMatchedOrbs(for: chains) {
                let columns = self.puzzleBoard.fillHoles()
                self.animateFallingOrbs(in: columns, completion: {
                    let columns = self.puzzleBoard.topUpOrbs()
                    self.animateNewOrbs(in: columns, completion: {
                        if let newChains = self.puzzleBoard.detectMatches() {
                            self.comboChains.append(contentsOf: newChains)
                            removeMatches(newChains)
                        } else {
                            self.resolveTurn()
                        }
                    })
                })
            }
        }
        
        if let chains = puzzleBoard.detectMatches() {
            comboChains.append(contentsOf: chains)
            removeMatches(chains)
        } else if didActivateTurn {
            resolveTurn()
        }
        
    }
    
    func resolveTurn() {
        //  Handle columns matched bonus
        comboChains.filter{ $0.chainType == .Column }.forEach { (chain) in
            removeRandomOrbs(number: 2, element: chain.element)
        }
        
        puzzleDelegate?.completedTurn(with: comboChains)
        
        comboChains.removeAll()
        comboCount = 0
        self.didActivateTurn = false
        self.isUserInteractionEnabled = true
    }
    
    func removeRandomOrbs(number: Int, element: OrbType) {
        var filteredOrbs = puzzleBoard.orbs.allItems.filter { $0.element == element }
        filteredOrbs.shuffle()
        
        
        for index in 0..<number {
            if !(filteredOrbs.count > index) {
                break
            }
            let column = filteredOrbs[index].column
            let row = filteredOrbs[index].row
            let element = puzzleBoard.orbs[column, row]?.element ?? .unknown
            
            if let sprite = puzzleBoard.orbs[column, row]?.sprite {
                if sprite.action(forKey: "removing") == nil {
                    //Shrink orbs in chain
                    let scaleAction = SKAction.scale(to: 0.1, duration: 0.3)
                    scaleAction.timingMode = .easeOut
                    //Wait according to combo sequence before starting animation
                    sprite.run(SKAction.sequence([scaleAction, SKAction.removeFromParent()]), withKey: "removing")
                }
            }
            run(SKAction.wait(forDuration: 0.3)) {
                self.puzzleBoard.orbs[column, row] = nil
                self.puzzleBoard.replaceOrb(at: column, row: row, notReplacedWithElements: [element])
            }
        }
        
    }

}

extension PuzzleBoardScene: TimerDelegate {
    
    func timerDidEnd() {
        if self.isSwiping == true {
            endMove()
        }
    }
    
}
