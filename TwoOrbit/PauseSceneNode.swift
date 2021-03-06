//
//  PauseScene.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 8/19/15.
//  Copyright © 2015 Jung Woo Kim. All rights reserved.
//

import SpriteKit

class PauseSceneNode: SKScene {
    var background: SKSpriteNode
    var restartButton: SKSpriteNode
    var homeButton: SKSpriteNode
    var continueButton: SKSpriteNode
    
    override init(size: CGSize) {
        background = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 1000, height: 1000))
        background.position = CGPoint(x: 0, y: 0)
        background.alpha = 0.6
        
        restartButton = SKSpriteNode(imageNamed: "RestartButtonImage")
        restartButton.size = CGSize(width: 70, height: 70)
        restartButton.position = CGPoint(x: -55, y: 0)
        
        homeButton = SKSpriteNode(imageNamed: "ToHomeImage")
        homeButton.size = CGSize(width: 70, height: 70)
        homeButton.position = CGPoint(x: 55, y: 0)
        
        continueButton = SKSpriteNode(imageNamed: "ContinueImage")
        continueButton.size = CGSize(width: 80, height: 80)
        continueButton.position = CGPoint(x: 0, y: 80)
        
        super.init(size: size)
        
        addChild(background)
        addChild(restartButton)
        addChild(homeButton)
        addChild(continueButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        
        if restartButton.containsPoint(location) {
            //sceneDelegate?.buttonTappedWithName("Restart")
        } else if homeButton.containsPoint(location) {
            //sceneDelegate?.buttonTappedWithName("ToHome")
        } else if continueButton.containsPoint(location) {
            //sceneDelegate?.buttonTappedWithName("Continue")
        }
    }
}