//
//  ViewController.swift
//  PuzzleGame
//
//  Created by Hoang Luong on 12/1/20.
//  Copyright © 2020 Hoang Luong. All rights reserved.
//

import UIKit
import SpriteKit

class PuzzleViewController: UIViewController {
    
    weak var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = self.view as? SKView
        
        let scene = GameScene(size: skView.frame.size)
        
        let stages = readStagesFromList()
        print(stages)
        scene.load(stages: stages)
        
        skView.presentScene(scene)
    }
    
    private func readStagesFromList() -> [Stage] {
        do {
            if let path = Bundle.main.path(forResource: "Stages", ofType: "plist") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = PropertyListDecoder()
                let stages = try decoder.decode([Stage].self, from: data)
                return stages
            }
        } catch let error {
            print(error.localizedDescription)
            return []
        }
        
        return []
    }

}

