//
//  GameService.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 6/2/21.
//  Copyright © 2021 Hoang Luong. All rights reserved.
//

/*
 
 Handle game logic, stage progress, items and powerups to apply etc.
 
 */

import Foundation
import UIKit

extension Notification.Name {
    static let TimerUpdated = Notification.Name("timerUpdatedNotification")
    static let TimebankDepleted = Notification.Name("timebankDepleted")
}

class GameService {
    
    var stageTargets = [StageInfo]()
    var stageIndex = 0
    
    static let shared = GameService()
    //  Set current stage
    var currentStageInfo: StageInfo!
    //  Game variables
    var moveTime: TimeInterval = 5.0
    var orbMultiplier: Float = 1.0
    
    var timebank: TimeInterval = 0 {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.TimerUpdated, object: nil, userInfo: ["time": timebank])
        }
    }
    var displayLink: CADisplayLink!
    
    init() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
        displayLink.add(to: .current,
                        forMode: RunLoop.Mode.default)
        displayLink.isPaused = true
        setTestLevels()
    }
    
    func startTimer() {
        displayLink.isPaused = false
    }
    
    func stopTimer() {
        displayLink.isPaused = true
    }
    
    @objc func updateTimer() {
        timebank -= max(0.02, 0)
        if timebank <= 0 {
            NotificationCenter.default.post(name: Notification.Name.TimebankDepleted, object: nil)
        }
    }
    
    func checkForObstructions() -> Obstruction? {
        return nil
    }
    
    func setTestLevels() {
        
        self.stageTargets.removeAll()
        self.stageIndex = 0
        
        //  Test targets
        self.stageTargets.append(StageInfo(timebank: 15, targetValue: 15))
        self.stageTargets.append(StageInfo(timebank: 15, targetValue: 20))
        
        currentStageInfo = stageTargets[stageIndex]
        timebank = currentStageInfo.timebank
    }
    
    func advanceStage() {
        stageIndex += 1
        currentStageInfo = stageTargets[stageIndex]
        timebank = currentStageInfo.timebank
    }
    
    func handle(_ matches: [Chain]) {
        currentStageInfo.update(with: matches, multiplier: orbMultiplier)
    }
    
}
