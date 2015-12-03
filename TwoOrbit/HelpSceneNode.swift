//
//  HowToPlayScene.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 8/19/15.
//  Copyright © 2015 Jung Woo Kim. All rights reserved.
//

import SpriteKit

class HelpSceneNode: SceneNode {
    var text1: SKLabelNode
    var text2: SKLabelNode
    
    override init(gameScene: GameScene) {
        text1 = SKLabelNode(text: "Tap anywhere to launch a sphere")
        text1.position = CGPoint(x: 0, y: -150)
        text1.fontSize = 20
        text1.fontColor = UIColor.blackColor()
        
        text2 = SKLabelNode(text: "Avoid moving spheres")
        text2.position = CGPoint(x: 0, y: 40)
        text2.fontSize = 20
        text2.fontColor = UIColor.blackColor()
        
        super.init(gameScene: gameScene)
        
        addChild(text1)
        addChild(text2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        gameScene.transitionToScene(.Menu)
    }
}