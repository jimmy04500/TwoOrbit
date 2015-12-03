//
//  GameSceneNode.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 12/2/15.
//  Copyright © 2015 Jung Woo Kim. All rights reserved.
//

import Foundation
import SpriteKit

class GameStartSceneNode: SceneNode {
    var tapToBeginText: SKLabelNode
    
    override init(gameScene: GameScene) {
        tapToBeginText = SKLabelNode(text: "Tap to begin")
        tapToBeginText.position = CGPoint(x: 0, y: 40)
        tapToBeginText.fontColor = UIColor.blackColor()
        tapToBeginText.fontSize = 30
        
        super.init(gameScene: gameScene)
        
        addChild(tapToBeginText)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        gameScene.transitionToScene(.InGame)
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}