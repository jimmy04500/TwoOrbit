//
//  SceneNode.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 12/2/15.
//  Copyright © 2015 Jung Woo Kim. All rights reserved.
//

import Foundation
import SpriteKit

class SceneNode: SKNode {
    weak var gameScene: GameScene!
    var container: SKSpriteNode
    
    init(gameScene: GameScene) {
        container = SKSpriteNode()
        container.size = gameScene.size
        
        super.init()
        
        self.gameScene = gameScene
        addChild(container)
    }
    
    func presentWithFadeIn() {
        self.alpha = 0.0
        self.position = CGPoint(x: 0, y: 0)
        self.userInteractionEnabled = true
        gameScene.addChild(self)
        
        let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.3)
        self.runAction(fadeIn)
    }
    
    func dismissWithFadeOut() {
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        self.runAction(fadeOut) {
            self.removeFromParent()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}