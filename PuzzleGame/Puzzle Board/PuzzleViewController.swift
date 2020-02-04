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
    
    var enemies = [Enemy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = self.view as? SKView
        
        let scene = PuzzleScene(size: skView.frame.size)
        
        loadEnemies()
        scene.load(enemy: enemies[0])
        skView.presentScene(scene)
    }
    
    private func loadEnemies() {
        do {
            if let path = Bundle.main.path(forResource: "EnemyPlist", ofType: "plist") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = PropertyListDecoder()
                let enemies = try decoder.decode([Enemy].self, from: data)
                self.enemies = enemies
            }
        } catch let error {
            print(error.localizedDescription)
        }

    }

}

