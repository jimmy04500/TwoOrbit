//
//  GameViewController.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 8/17/15.
//  Copyright (c) 2015 Jung Woo Kim. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    var skView: SKView!
    var menuscene: MenuSceneNode!
    var gamescene: GameScene!
    
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        skView = self.view as! SKView
        //skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        gamescene = GameScene(size: skView.bounds.size)
        gamescene.scaleMode = .AspectFill
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "highscore")
        NSUserDefaults.standardUserDefaults().synchronize()
        skView.presentScene(gamescene)
        
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (viewController: UIViewController?, error: NSError?) -> Void in
            if let vc = viewController {
                self.presentViewController(vc, animated: true, completion: nil)
            } else {
                //print(GKLocalPlayer.localPlayer().authenticated)
            }
        }
    }
    
    // MARK: GameSceneDelegate methods
    func didRequestGameCenter() {
        let gamecenterVC = GKGameCenterViewController()
        gamecenterVC.gameCenterDelegate = self
        gamecenterVC.viewState = .Leaderboards
        gamecenterVC.leaderboardIdentifier = "TwoOrbit_leaderboard"
        presentViewController(gamecenterVC, animated: true, completion: nil)
    }
    
    
    // MARK: GameCenterDelegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func updateHighscore() {
        let curhigh = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        if score > curhigh {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
