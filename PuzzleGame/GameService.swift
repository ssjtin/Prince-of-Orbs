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
    var moveTime: TimeInterval = 4.0
    var orbMultiplier: Float = 1.0
    //  One time use items held
    var heldItems = [Item]()
    var itemLimit = 1
    //  Coin counter
    var coinCount: Int = 10
    
    init() {
        setTestLevels()
    }
    
    func setTestLevels() {
        
        self.stageTargets.removeAll()
        self.stageIndex = 0
        
        //  Test targets
        self.stageTargets.append(StageInfo(turns: 3, orbTargets: [OrbTarget(element: .Dark, targetCount: 3)]))
        
        self.stageTargets.append(StageInfo(turns: 3, orbTargets: [OrbTarget(element: .Fire, targetCount: 3),
                                                                        OrbTarget(element: .Water, targetCount: 3)]))
        
        self.stageTargets.append(StageInfo(turns: 3, orbTargets: [OrbTarget(element: .Fire, targetCount: 7),
                                                                        OrbTarget(element: .Grass, targetCount: 4)]))
        
        self.stageTargets.append(StageInfo(turns: 5, orbTargets: [OrbTarget(element: .Fire, targetCount: 3),
                                                                        OrbTarget(element: .Water, targetCount: 3),
                                                                        OrbTarget(element: .Grass, targetCount: 10)]))
        
        self.stageTargets.append(StageInfo(turns: 5, orbTargets: [OrbTarget(element: .Fire, targetCount: 6),
                                                                        OrbTarget(element: .Water, targetCount: 6),
                                                                        OrbTarget(element: .Grass, targetCount: 10)]))
        
        self.stageTargets.append(StageInfo(turns: 5, orbTargets: [OrbTarget(element: .Fire, targetCount: 10),
                                                                        OrbTarget(element: .Water, targetCount: 20),
                                                                        OrbTarget(element: .Grass, targetCount: 10)]))
        
        self.stageTargets.append(StageInfo(turns: 6, orbTargets: [OrbTarget(element: .Fire, targetCount: 12),
                                                                        OrbTarget(element: .Water, targetCount: 12),
                                                                        OrbTarget(element: .Grass, targetCount: 12),
                                                                        OrbTarget(element: .Light, targetCount: 12),
                                                                        OrbTarget(element: .Dark, targetCount: 12)]))
        
        self.stageTargets.append(StageInfo(turns: 7, orbTargets: [OrbTarget(element: .Fire, targetCount: 12),
                                                                        OrbTarget(element: .Water, targetCount: 12),
                                                                        OrbTarget(element: .Grass, targetCount: 12),
                                                                        OrbTarget(element: .Light, targetCount: 15),
                                                                        OrbTarget(element: .Dark, targetCount: 15)]))
        
        self.stageTargets.append(StageInfo(turns: 8, orbTargets: [OrbTarget(element: .Fire, targetCount: 30)]))
        
        currentStageInfo = stageTargets[stageIndex]
    }
    
    func advanceStage() {
        stageIndex += 1
        currentStageInfo = stageTargets[stageIndex]
    }
    
    func handle(_ matches: [Chain]) {
        currentStageInfo.update(with: matches, multiplier: orbMultiplier)
        coinCount += matches.numOfCoinsMatched
    }
    
    func handle(item: Item) {
        if item.type == .oneTime {
            heldItems.append(item)
        } else {
            if item.effect == .timeExtend {
                moveTime += Double(item.effectValue)
            }
            if item.effect == .attackBoost {
                orbMultiplier += item.effectValue
            }
        }
        coinCount -= item.cost
    }
    
}
