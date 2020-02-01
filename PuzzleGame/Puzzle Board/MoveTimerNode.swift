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

class MoveTimerNode: SKShapeNode {
    
    var timeLimit: TimeInterval = 4.0
    var isActive: Bool = false
    var timer: Timer?
    
    weak var delegate: TimerDelegate?
    
    init(size: CGSize) {
        super.init()
        
        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: 2).cgPath
        fillColor = .blue
        lineWidth = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startTimer() {
        guard !isActive else { return }
        
        isActive = true
        timer = Timer.scheduledTimer(withTimeInterval: timeLimit, repeats: false, block: { (_) in
            self.delegate?.timerDidEnd()
            self.timer = nil
            self.isActive = false
        })
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        isActive = false
    }
    
}
