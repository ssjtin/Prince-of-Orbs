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

class GameService {
    
    var stageTargets = [StageInfo]()
    var stageIndex = 0
    
    static let shared = GameService()
    //  Set current stage
    var currentStageInfo: StageInfo!
    //  Game variables
    var moveTime: TimeInterval = 5.0
    var orbMultiplier: Float = 1.0
    
    init() {
        setTestLevels()
    }
    
    func checkForObstructions() -> Obstruction? {
        return nil
    }
    
    func setTestLevels() {
        
        self.stageTargets.removeAll()
        self.stageIndex = 0
        
        //  Test targets
        self.stageTargets.append(StageInfo(turns: 3, targetValue: 15))
        self.stageTargets.append(StageInfo(turns: 3, targetValue: 20))
        
        currentStageInfo = stageTargets[stageIndex]
    }
    
    func advanceStage() {
        stageIndex += 1
        currentStageInfo = stageTargets[stageIndex]
    }
    
    func handle(_ matches: [Chain]) {
        currentStageInfo.update(with: matches, multiplier: orbMultiplier)
    }
    
}
