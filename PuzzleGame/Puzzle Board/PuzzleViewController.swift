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
    
    //  Target
    
    weak var skView: SKView!
    
    @IBOutlet weak var puzzleBoardView: SKView!
    
    @IBOutlet weak var stageImageView: UIImageView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var darkLabel: UILabel!
    
    @IBOutlet weak var turnsLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var stageLabel: UILabel!
    
    var gameService = GameService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = self.view as? SKView
        
        let scene = PuzzleBoardScene(size: puzzleBoardView.frame.size)
        
        scene.puzzleDelegate = self

        puzzleBoardView.presentScene(scene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        syncTargetLabels()
    }
    
    func syncTargetLabels() {
        let stageInfo = GameService.shared.currentStageInfo!
        
        stageInfo.orbTargets.forEach { (target) in
            switch target.element {
            case .Fire: redLabel.text = target.remainingCount.asString
            case .Water: blueLabel.text = target.remainingCount.asString
            case .Grass: greenLabel.text = target.remainingCount.asString
            case .Light: goldLabel.text = target.remainingCount.asString
            case .Dark: darkLabel.text = target.remainingCount.asString
            default: ()
            }
        }
        turnsLabel.text = "Turns remaning : \(stageInfo.turns)"
        stageLabel.text = "Stage \(gameService.stageIndex+1)"
        coinLabel.text = gameService.coinCount.asString
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
    
    func showItemShop() {
        let alert = UIAlertController(title: "ITEM SHOP", message: "", preferredStyle: .actionSheet)
        let items = Item.getTestItems()
        let firstItem = UIAlertAction(title: items[0].description, style: .default) { (action) in
            self.handleSelected(item: items[0])
        }
        let secondItem = UIAlertAction(title: items[1].description, style: .default) { (action) in
            self.handleSelected(item: items[1])
        }
        let thirdItem = UIAlertAction(title: items[2].description, style: .default) { (action) in
            self.handleSelected(item: items[2])
        }
        let quitAction = UIAlertAction(title: "Kechi da ne - CLOSE", style: .cancel) { (action) in
            self.advanceToNextStage()
        }
        alert.addAction(firstItem)
        alert.addAction(secondItem)
        alert.addAction(thirdItem)
        alert.addAction(quitAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleSelected(item: Item) {
        //  Check if item can be afforded
        if item.cost <= gameService.coinCount {
            gameService.handle(item: item)
            advanceToNextStage()
        } else {
            let alert = UIAlertController(title: "You're TOO POOR!", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.showItemShop()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func advanceToNextStage() {
        gameService.advanceStage()
        syncTargetLabels()
    }
    
    func presentGameOverAlert(victory: Bool) {
        let title = victory ? "Congrats, you slayed the dragon. Play again?" : "You lose, good day sir"
        let alert = UIAlertController(title: "Game over", message: title, preferredStyle: .alert)
        let repeatAction = UIAlertAction(title: "Play again?", style: .default) { (action) in
            self.gameService.setTestLevels()
            self.syncTargetLabels()
        }
        alert.addAction(repeatAction)
        self.present(alert, animated: true, completion: nil)
    }

}

extension PuzzleViewController: PuzzleBoardDelegate {
    
    func completedTurn(with matches: [Chain]) {
        gameService.handle(matches)
        syncTargetLabels()
        
        if gameService.currentStageInfo.outOfTurns && !gameService.currentStageInfo.completed {
            presentGameOverAlert(victory: false)
        } else if gameService.currentStageInfo.completed {
            if (gameService.stageIndex + 1) < gameService.stageTargets.count {
                showItemShop()
            } else {
                presentGameOverAlert(victory: true)
            }
        }
    }
    
}
