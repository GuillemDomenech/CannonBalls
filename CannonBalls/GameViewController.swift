//
//  GameViewController.swift
//  CannonBalls
//
//  Created by Guillem Domènech Rofín on 15/04/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var startView: UIView!
    @IBOutlet var gameView: UIView!
    @IBOutlet var enterNameView: UIView!
    @IBOutlet var rankingView: UIView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var enterNameScoreLabel: UILabel!
    @IBOutlet var rankingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.backgroundColor = UIColor(hex: 0xCDE6F8)
                
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
                
                resetViewsVisibility()
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(startTapDetected))
        startView.addGestureRecognizer(tap)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setScore(score: Int) {
        scoreLabel.text = String(score)
    }
    
    func resetViewsVisibility() {
        gameView.isHidden = true
        enterNameView.isHidden = true
        rankingView.isHidden = true
        startView.isHidden = false
        startView.alpha = 1
        gameView.alpha = 1
        enterNameView.alpha = 1
        rankingView.alpha = 1
    }
    
    func toggleStartView(show: Bool) {
        UtilFunctions.transitionView(startView, show: show, duration: 0.5)
    }
    
    func toggleGameView(show: Bool) {
        UtilFunctions.transitionView(gameView, show: show, duration: 0.5)
    }
    
    func toggleEnterNameView(show: Bool) {
        UtilFunctions.transitionView(enterNameView, show: show, duration: 0.5)
    }
    
    func toggleRankingView(show: Bool) {
        UtilFunctions.transitionView(rankingView, show: show, duration: 0.5)
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        guard let text = textField.text, let currentGame = currentGame else { return }
        
        if text.trimmingCharacters(in: .whitespaces).isEmpty { return }
        
        sender.superview?.endEditing(true)
        
        currentGame.rankingManager.addScore(nick: text, score: currentGame.score)
        
        toggleEnterNameView(show: false)
        
        rankingLabel.text = currentGame.rankingManager.getRankString()
        toggleRankingView(show: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        sender.superview?.endEditing(true)
        print("Restarting game")
        restartGameUI()
    }
    
    @IBAction func editingEnd(_ sender: UITextField) {
        print("editing ended")
        sender.resignFirstResponder()
    }
    
    @objc func startTapDetected() {
        print("Starting the game!")
        toggleGameView(show: true)
        toggleStartView(show: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentGame?.gameOver = false
        }
    }
    @IBAction func rankingContinuePressed(_ sender: UIButton) {
        sender.superview?.endEditing(true)
        print("Ranking continue")
        restartGameUI()
    }
    
    func restartGameUI() {
        toggleRankingView(show: false)
        toggleEnterNameView(show: false)
        toggleStartView(show: true)
        currentGame?.restart()
    }
}
