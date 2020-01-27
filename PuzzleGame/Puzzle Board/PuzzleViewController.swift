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
        
        let scene = BattleScene(size: skView.frame.size)
        
        skView.presentScene(scene)
    }


}

