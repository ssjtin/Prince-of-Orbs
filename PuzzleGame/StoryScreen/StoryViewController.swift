//
//  StoryViewController.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 8/1/21.
//  Copyright © 2021 Hoang Luong. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    
    var stageTargets = [StageInfo]()
    var stageIndex = 0
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.stageTargets.append(StageInfo(turns: 3, orbTargets: [OrbTarget(element: .Fire, targetCount: 12),
                                                                        OrbTarget(element: .Water, targetCount: 12),
                                                                        OrbTarget(element: .Grass, targetCount: 12),
                                                                        OrbTarget(element: .Light, targetCount: 12),
                                                                        OrbTarget(element: .Dark, targetCount: 12),]))
        
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
        
        button.setTitle("Stage 1", for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showPuzzle", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPuzzle" {
            stageIndex += 1
            button.setTitle("Stage \(stageIndex + 1)", for: .normal)
        }
    }

    
}
