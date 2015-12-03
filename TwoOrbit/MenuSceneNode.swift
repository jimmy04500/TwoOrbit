//
//  MenuScene.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 8/17/15.
//  Copyright © 2015 Jung Woo Kim. All rights reserved.
//

import SpriteKit


class MenuSceneNode: SceneNode {
    var gameCenterButton: SKSpriteNode
    var helpButton: SKSpriteNode
    var startPlayButton: SKSpriteNode
    var logoImage: SKSpriteNode
    
    override init(gameScene: GameScene) {
        logoImage = SKSpriteNode(imageNamed: "Logo")
        logoImage.size = CGSize(width: 100, height: 100)
        logoImage.position = CGPoint(x: 10, y: 45)
        
        helpButton = SKSpriteNode(imageNamed: "HelpButtonImage")
        helpButton.size = CGSize(width: 60, height: 60)
        helpButton.position = CGPoint(x: -100, y: -150)
        
        startPlayButton = SKSpriteNode(imageNamed: "StartPlayImage")
        startPlayButton.size = CGSize(width: 100, height: 100)
        startPlayButton.position = CGPoint(x: 0, y: -150)
        
        gameCenterButton = SKSpriteNode(imageNamed: "GameCenterImage")
        gameCenterButton.size = CGSize(width: 60, height: 60)
        gameCenterButton.position = CGPoint(x: 100, y: -150)
        
        super.init(gameScene: gameScene)
        
        addChild(logoImage)
        addChild(helpButton)
        addChild(startPlayButton)
        addChild(gameCenterButton)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        
        if helpButton.containsPoint(location) {
            gameScene.transitionToScene(.Help)
        } else if startPlayButton.containsPoint(location) {
            gameScene.transitionToScene(.InGame)
        } else if gameCenterButton.containsPoint(location) {
            //sceneDelegate?.buttonTappedWithName("GameCenter")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}