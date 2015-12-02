//
//  GameOverScene.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 8/17/15.
//  Copyright © 2015 Jung Woo Kim. All rights reserved.
//

import SpriteKit

protocol OverlaySceneDelegate {
    func buttonTappedWithName(name: String)
}

class GameOverScene: SKNode {
    var sceneDelegate: OverlaySceneDelegate?
    
    var background: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    var gameOverText: SKLabelNode!
    var restartButton: SKSpriteNode!
    var homeButton: SKSpriteNode!
    
    override init() {
        super.init()
        
        background = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 1000, height: 1000))
        background.position = CGPoint(x: 0, y: 0)
        background.alpha = 0.6
        addChild(background)
        
        gameOverText = SKLabelNode(text: "Game Over")
        gameOverText.position = CGPoint(x: 0, y: 150)
        gameOverText.fontSize = 50
        addChild(gameOverText)
        
        restartButton = SKSpriteNode(imageNamed: "RestartButtonImage")
        restartButton.name = "Restart"
        restartButton.size = CGSize(width: 70, height: 70)
        restartButton.position = CGPoint(x: -55, y: -80)
        addChild(restartButton)
        
        homeButton = SKSpriteNode(imageNamed: "ToHomeImage")
        homeButton.name = "ToHome"
        homeButton.size = CGSize(width: 70, height: 70)
        homeButton.position = CGPoint(x: 55, y: -80)
        addChild(homeButton)
        
        highscoreLabel = SKLabelNode(text: "Best: 0")
        highscoreLabel.position = CGPoint(x: 0, y: 50)
        highscoreLabel.fontColor = UIColor.whiteColor()
        highscoreLabel.fontSize = 30
        addChild(highscoreLabel)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 0, y: 10)
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.fontSize = 30
        addChild(scoreLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        if restartButton.containsPoint(location) {
            sceneDelegate?.buttonTappedWithName("Restart")
        } else if homeButton.containsPoint(location) {
            sceneDelegate?.buttonTappedWithName("ToHome")
        }
    }
}
