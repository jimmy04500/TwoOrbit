//
//  MenuScene.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 8/17/15.
//  Copyright © 2015 Jung Woo Kim. All rights reserved.
//

import SpriteKit


class MenuScene: SKNode {
    var sceneDelegate: OverlaySceneDelegate?
    
    var gameCenterButton: SKSpriteNode!
    var helpButton: SKSpriteNode!
    var startPlayButton: SKSpriteNode!
    var logoImage: SKSpriteNode!
    
    override init() {
        super.init()
        
        logoImage = SKSpriteNode(imageNamed: "Logo")
        logoImage.size = CGSize(width: 100, height: 100)
        logoImage.position = CGPoint(x: 10, y: 45)
        addChild(logoImage)
        
        helpButton = SKSpriteNode(imageNamed: "HelpButtonImage")
        helpButton.size = CGSize(width: 60, height: 60)
        helpButton.position = CGPoint(x: -100, y: -150)
        addChild(helpButton)
        
        startPlayButton = SKSpriteNode(imageNamed: "StartPlayImage")
        startPlayButton.size = CGSize(width: 100, height: 100)
        startPlayButton.position = CGPoint(x: 0, y: -150)
        addChild(startPlayButton)
        
        gameCenterButton = SKSpriteNode(imageNamed: "GameCenterImage")
        gameCenterButton.size = CGSize(width: 60, height: 60)
        gameCenterButton.position = CGPoint(x: 100, y: -150)
        addChild(gameCenterButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        
        if helpButton.containsPoint(location) {
            sceneDelegate?.buttonTappedWithName("Help")
        } else if startPlayButton.containsPoint(location) {
            sceneDelegate?.buttonTappedWithName("StartPlay")
        } else if gameCenterButton.containsPoint(location) {
            sceneDelegate?.buttonTappedWithName("GameCenter")
        }
    }
}