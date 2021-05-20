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
    var timebankTimer: Timer?
    
    var mainBar = SKSpriteNode()
    var timebankLabel = SKLabelNode()
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

        timebankLabel.text = String(GameService.shared.clockCount)
        timebankLabel.zPosition = 10
        timebankLabel.position = CGPoint(x: 140, y: -18)
        addChild(timebankLabel)
        
        let label = SKLabelNode(text: "TIMEBANK")
        label.position = CGPoint(x: 140, y: 14)
        label.fontSize = 12
        addChild(label)
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
            //  End of normal time, start taking out timebanks
            if GameService.shared.clockCount > 0 {
                self.timebankLabel.addPulseEffect(circleOfRadius: 20)
                self.timebankTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    GameService.shared.clockCount -= 1
                    self.timebankLabel.text = String(GameService.shared.clockCount)
                    if GameService.shared.clockCount == 0 {
                        self.endTimers()
                    }

                })
                
            } else {
                self.endTimers()
            }

        })
    }
    
    func endTimers() {
        self.timebankLabel.cancelPulse()
        self.delegate?.timerDidEnd()
        self.timer = nil
        self.timebankTimer?.invalidate()
        self.timebankTimer = nil
        self.isActive = false
        self.reset()
    }
    
    func cancelTimer() {
        self.timebankLabel.cancelPulse()
        timer?.invalidate()
        timer = nil
        timebankTimer?.invalidate()
        timebankTimer = nil
        isActive = false
        mainBar.removeAllActions()
        self.reset()
    }
    
    func reset() {
        mainBar.scale(to: CGSize(width: length, height: 30))
    }
    
}

extension SKLabelNode {
    
    private static let fillColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 0.45)
    
    func addPulseEffect(circleOfRadius: CGFloat, backgroundColor: UIColor = fillColor) {
        let pulseNode = SKShapeNode(circleOfRadius: 20)
        pulseNode.fillColor = backgroundColor
        pulseNode.lineWidth = 0.0
        pulseNode.position = CGPoint(x: 0, y: 10)
        self.addChild(pulseNode)
        let scale = SKAction.scale(to: 1.18, duration: 0.6)
        let fadeOut = SKAction.scale(to: 1.0, duration: 0.4)
        let pulseGroup = SKAction.sequence([scale, fadeOut])
        let repeatSequence = SKAction.repeatForever(pulseGroup)
        pulseNode.run(repeatSequence)
    }
    
    func cancelPulse() {
        self.children.first?.removeAllActions()
        self.removeAllChildren()
    }

}
