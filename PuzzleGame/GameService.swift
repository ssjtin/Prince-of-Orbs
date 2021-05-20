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
    //  clock counter
    var clockCount: Int = 0
    
    init() {
        setTestLevels()
    }
    
    func checkForObstructions() -> Obstruction? {
        if stageIndex > 2 {
            return .slime(number: 2)
        }
        return nil
    }
    
    func setTestLevels() {
        
        self.stageTargets.removeAll()
        self.stageIndex = 0
        self.clockCount = 0
        
        //  Test targets
        self.stageTargets.append(StageInfo(turns: 3, orbTargets: [OrbTarget(element: .Dark, targetCount: 3)]))
        
        self.stageTargets.append(StageInfo(turns: 4, orbTargets: [OrbTarget(element: .Fire, targetCount: 4),
                                                                        OrbTarget(element: .Water, targetCount: 3)]))
        
        self.stageTargets.append(StageInfo(turns: 4, orbTargets: [OrbTarget(element: .Fire, targetCount: 4),
                                                                        OrbTarget(element: .Grass, targetCount: 3),
                                                                        OrbTarget(element: .Water, targetCount: 3)]))
        
        self.stageTargets.append(StageInfo(turns: 5, orbTargets: [OrbTarget(element: .Fire, targetCount: 3),
                                                                        OrbTarget(element: .Water, targetCount: 3),
                                                                        OrbTarget(element: .Grass, targetCount: 6)]))
        
        self.stageTargets.append(StageInfo(turns: 6, orbTargets: [OrbTarget(element: .Fire, targetCount: 12)]))
        
        self.stageTargets.append(StageInfo(turns: 8, orbTargets: [OrbTarget(element: .Water, targetCount: 10),
                                                                        OrbTarget(element: .Grass, targetCount: 10)]))
        
        self.stageTargets.append(StageInfo(turns: 8, orbTargets: [OrbTarget(element: .Fire, targetCount: 6),
                                                                        OrbTarget(element: .Water, targetCount: 6),
                                                                        OrbTarget(element: .Grass, targetCount: 6),
                                                                        OrbTarget(element: .Light, targetCount: 6),
                                                                        OrbTarget(element: .Dark, targetCount: 6)]))
        
        self.stageTargets.append(StageInfo(turns: 10, orbTargets: [OrbTarget(element: .Fire, targetCount: 20)]))
        
        currentStageInfo = stageTargets[stageIndex]
    }
    
    func advanceStage() {
        stageIndex += 1
        currentStageInfo = stageTargets[stageIndex]
    }
    
    func handle(_ matches: [Chain]) {
        currentStageInfo.update(with: matches, multiplier: orbMultiplier)
        clockCount += matches.numOfclocksMatched
    }
    
}
