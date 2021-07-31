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
    
    @IBOutlet weak var timerLabel: UITextView!
    @IBOutlet weak var puzzleBoardView: SKView!
    @IBOutlet weak var stageImageView: UIImageView!
    @IBOutlet weak var stageLabel: UILabel!
    
    var gameService = GameService.shared
    
    var puzzleBoardScene: PuzzleBoardScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = self.view as? SKView
        
        self.puzzleBoardScene = PuzzleBoardScene(size: puzzleBoardView.frame.size)
        
        self.puzzleBoardScene.puzzleDelegate = self

        puzzleBoardView.presentScene(puzzleBoardScene)
        stageImageView.layer.zPosition = -1
        NotificationCenter.default.addObserver(forName: .TimerUpdated, object: nil, queue: nil) { notification in
            if let info = notification.userInfo, let timeValue = info["time"] as? TimeInterval {
                print(timeValue)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        syncTargetLabels(isInitialForStage: true)
    }
    
    func syncTargetLabels(isInitialForStage: Bool = false) {
        let stageInfo = GameService.shared.currentStageInfo!
        stageLabel.text = "Stage \(gameService.stageIndex+1)"
    }
    
//    private func readStagesFromList() -> [Stage] {
//        do {
//            if let path = Bundle.main.path(forResource: "Stages", ofType: "plist") {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path))
//                let decoder = PropertyListDecoder()
//                let stages = try decoder.decode([Stage].self, from: data)
//                return stages
//            }
//        } catch let error {
//            print(error.localizedDescription)
//            return []
//        }
//
//        return []
//    }
    
    func advanceToNextStage() {
        gameService.advanceStage()
        syncTargetLabels(isInitialForStage: true)
    }
    
    func handle(obstruction: Obstruction) {
//        switch obstruction {
//        case .slime(let number):
//            puzzleBoardScene.puzzleBoard.putSlimes(number: number)
//        default: ()
//        }
    }
    
    func presentGameOverAlert(victory: Bool) {
        let title = victory ? "Congrats, you slayed the dragon. Play again?" : "You lose, good day sir"
        let alert = UIAlertController(title: "Game over", message: title, preferredStyle: .alert)
        let repeatAction = UIAlertAction(title: "Play again?", style: .default) { (action) in
            self.gameService.setTestLevels()
            self.syncTargetLabels(isInitialForStage: true)
            self.puzzleBoardScene.puzzleBoard.refreshBoard()
            self.puzzleBoardScene.moveTimer.timebankLabel.text = "0"
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
                advanceToNextStage()
            } else {
                presentGameOverAlert(victory: true)
            }
        } else {
            if let obstruction = gameService.checkForObstructions() {
                handle(obstruction: obstruction)
            }
        }
        
    }
    
}
