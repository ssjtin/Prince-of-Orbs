//
//  MoveTimer.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 1/2/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import SpriteKit

protocol TimerDelegate: class {
    func timerDidEnd()
}

class MoveTimerNode: SKSpriteNode {
    
    var isActive: Bool = false
    var timer: Timer?
    
    var mainBar = SKSpriteNode()
    var length: CGFloat = 200
    
    weak var delegate: TimerDelegate?
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        
        mainBar.color = .green
        mainBar.size = CGSize(width: size.width-3, height: size.height-3)
        mainBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        mainBar.zPosition = 10
        mainBar.position = CGPoint(x: -size.width/2, y: 0)
        addChild(mainBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startTimer() {
        guard !isActive else { return }
        
        
        isActive = true
        let scaleAction = SKAction.scaleX(to: 0, duration: GameService.shared.moveTime)
        mainBar.run(scaleAction, withKey: "timeLimitAnimate")
        
        timer = Timer.scheduledTimer(withTimeInterval: GameService.shared.moveTime, repeats: false, block: { (_) in
            self.delegate?.timerDidEnd()
            self.timer = nil
            self.isActive = false
            self.reset()
        })
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        isActive = false
        mainBar.removeAllActions()
        self.reset()
    }
    
    func reset() {
        mainBar.scale(to: CGSize(width: length, height: 30))
    }
    
}
