//
//  GameScene.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 8/17/15.
//  Copyright (c) 2015 Jung Woo Kim. All rights reserved.
//

import SpriteKit
import GameKit

/*
protocol GameSceneDelegate {
    func didRequestGameCenter()
}
*/
enum GameSceneType {
    case Menu, Pause, Help, GameOver, GameStart, InGame
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let BallCategory: UInt32 = 0x1 << 0
    let ObstacleCategory: UInt32 = 0x1 << 1
    let TargetCategory: UInt32 = 0x1 << 2
    
    var livesLeft = 5
    var score = 0
    var livesNodes: [SKSpriteNode]!
    var scoreLabel: SKLabelNode!
    
    
    var currentScene: SceneNode?
    var uiElemNode: SKNode!
    
    var obstacle1: SKSpriteNode!
    var obstacle2: SKSpriteNode!
    var target: SKSpriteNode!
    
    var pauseButton: SKSpriteNode!
    
    var animateIn: SKAction!
    var animateOut: SKAction!
    
    override init(size: CGSize) {
        // Actions
        animateIn = SKAction.fadeInWithDuration(0.3)
        animateOut = SKAction.fadeOutWithDuration(0.3)
        
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.whiteColor()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self

        // Game Elements initialization
        target = SKSpriteNode(imageNamed: "GreenPiece")
        target.name = "Target"
        target.position = CGPoint(x: 0, y: size.height/2+40)
        target.size = CGSize(width: 50, height: 50)
        target.physicsBody = SKPhysicsBody(rectangleOfSize: target.size)
        target.physicsBody?.dynamic = false
        target.physicsBody?.categoryBitMask = TargetCategory
        target.physicsBody?.contactTestBitMask = BallCategory
        target.physicsBody?.collisionBitMask = 0x0
        addChild(target)
        
        
        // Obstacles
        let center = CGPoint(x: 0, y: 50)
        
        let emitterRed = SKEmitterNode(fileNamed: "ObstacleTrailRed.sks")!
        emitterRed.targetNode = self
        
        obstacle1 = SKSpriteNode(imageNamed: "Obstacle1Image")
        obstacle1.size = CGSize(width: 30, height: 30)
        obstacle1.name = "Obstacle"
        obstacle1.alpha = 0.8
        obstacle1.speed = 0.4
        obstacle1.addChild(emitterRed)
        obstacle1.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle1.size)
        obstacle1.physicsBody?.dynamic = false
        obstacle1.physicsBody?.categoryBitMask = ObstacleCategory
        obstacle1.physicsBody?.contactTestBitMask = BallCategory
        obstacle1.physicsBody?.collisionBitMask = 0x0
        addChild(obstacle1)
        
        let circle = UIBezierPath(arcCenter: center, radius: 120, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: false)
        let followCircle = SKAction.followPath(circle.CGPath, asOffset: false, orientToPath: true, speed: 400)
        let obs1Move = SKAction.repeatActionForever(followCircle)
        obstacle1.runAction(obs1Move)
        
        
        
        let emitterBlue = SKEmitterNode(fileNamed: "ObstacleTrailBlue.sks")!
        emitterBlue.targetNode = self
        
        obstacle2 = SKSpriteNode(imageNamed: "Obstacle2Image")
        obstacle2.size = CGSize(width: 30, height: 30)
        obstacle2.name = "Obstacle"
        obstacle2.alpha = 0.8
        obstacle2.speed = 0.4
        obstacle2.addChild(emitterBlue)
        obstacle2.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle2.size)
        obstacle2.physicsBody?.dynamic = false
        obstacle2.physicsBody?.categoryBitMask = ObstacleCategory
        obstacle2.physicsBody?.contactTestBitMask = BallCategory
        obstacle2.physicsBody?.collisionBitMask = 0x0
        addChild(obstacle2)
        
        let circle2 = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat(M_PI), endAngle: CGFloat(M_PI), clockwise: true)
        let followCircle2 = SKAction.followPath(circle2.CGPath, asOffset: false, orientToPath: true, speed: 550)
        let obs2Move = SKAction.repeatActionForever(followCircle2)
        obstacle2.runAction(obs2Move)
        
        transitionToScene(.Menu)
    }
    
    func transitionToScene(sceneType: GameSceneType) {
        if let currentScene = currentScene {
            currentScene.dismissWithFadeOut()
        }
        switch sceneType {
        case .Menu:
            currentScene = MenuSceneNode(gameScene: self)
            currentScene!.presentWithFadeIn()
        case .Help:
            currentScene = HelpSceneNode(gameScene: self)
            currentScene!.presentWithFadeIn()
        case .GameStart:
            currentScene = GameStartSceneNode(gameScene: self)
            currentScene!.presentWithFadeIn()
        case .InGame:
            currentScene = nil
            presentGameSceneWithFadeIn()
        case .GameOver:
            currentScene = GameOverSceneNode(gameScene: self)
            currentScene!.presentWithFadeIn()
        default:
            fatalError("Unknown Scene Type")
        }
    }
    
    func presentGameSceneWithFadeIn() {
        userInteractionEnabled = true
        livesLeft = 5
        score = 0
        obstacle1.runAction(SKAction.speedTo(0.4, duration: 0.5))
        obstacle2.runAction(SKAction.speedTo(0.4, duration: 0.5))
        
        // UI initialization
        uiElemNode = SKNode()
        
        pauseButton = SKSpriteNode(imageNamed: "PauseIcon")
        pauseButton.size = CGSize(width: 35, height: 35)
        pauseButton.position = CGPoint(x: size.width/2-50, y: size.height/2-60)
        pauseButton.alpha = 0.0
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position = CGPoint(x: 0, y: size.height/2-60)
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.fontSize = 36
        
        livesNodes = [SKSpriteNode]()
        for i in 0..<5 {
            let lifeNode = SKSpriteNode(imageNamed: "LifeImage")
            lifeNode.name = "Life"
            lifeNode.size = CGSize(width: 20, height: 20)
            lifeNode.position = CGPoint(x: -size.width/2 + CGFloat((i+1) * 22), y: size.height/2-100)
            livesNodes.append(lifeNode)
        }
        
        // Animate lives
        for i in 0..<5 {
            livesNodes[i].xScale = 0.1
            livesNodes[i].yScale = 0.1
            uiElemNode.addChild(livesNodes[i])
            let waitAndAnimate = SKAction.sequence([SKAction.waitForDuration(0.1*Double(i+1)), SKAction.scaleTo(1.0, duration: 0.2)])
            livesNodes[i].runAction(waitAndAnimate)
        }
        
        uiElemNode.addChild(pauseButton)
        uiElemNode.addChild(scoreLabel)
        
        addChild(uiElemNode)
    }
    
    func dismissGameSceneWithFadeIn() {
        uiElemNode.removeFromParent()
    }
    
    override func didMoveToView(view: SKView) {
        
    }
    
    func loadHighscore() {
        let highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        //gameOverScene.highscoreLabel.text = "Best: \(highscore)"
    }
    
    func updateHighscore() {
        /*
        let curhigh = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        if score > curhigh {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if GKLocalPlayer.localPlayer().authenticated {
                let bestscore = GKScore(leaderboardIdentifier: "TwoOrbit_leaderboard")
                bestscore.value = Int64(score)
                GKScore.reportScores([bestscore], withCompletionHandler: nil)
            }
        }
        */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        if pauseButton.containsPoint(location) {
        
        } else {
            let toAddBall = createBall()
            addChild(toAddBall)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.node?.name == "Obstacle" && bodyB.node?.name == "Ball") || (bodyA.node?.name == "Ball" && bodyB.node?.name == "Obstacle") {
            // Ball hit obstacle
            
            if livesLeft > 0 {
                let ball = bodyB.node!.name == "Ball" ? bodyB.node! : bodyA.node!
                removeNodeWithExplosion(ball)
                decrementLife()
            }
            
            if livesLeft <= 0 {
                userInteractionEnabled = false
                
                enumerateChildNodesWithName("Ball") {
                    (node: SKNode, stop: UnsafeMutablePointer<ObjCBool>) in
                    self.removeNodeWithExplosion(node)
                }
                
                updateHighscore()
                loadHighscore()
                let sceneWaitAction = SKAction.waitForDuration(0.8)
                runAction(sceneWaitAction) {
                    self.dismissGameSceneWithFadeIn()
                    self.transitionToScene(.GameOver)
                }
            }
        } else if (bodyA.node?.name == "Ball" && bodyB.node?.name == "Target") || (bodyA.node == target && bodyB.node?.name == "Ball") {
            // Ball hit target
            let ball = bodyB.node!.name == "Ball" ? bodyB.node! : bodyA.node!
            ball.removeFromParent()
            
            score++
            scoreLabel.text = "\(score)"
            scaleDiffWithScore(score)
        }
    }
    
    func scaleDiffWithScore(score: Int) {
        if score >= 60 {
            obstacle1.runAction(SKAction.speedTo(1.0, duration: 0.5))
            obstacle2.runAction(SKAction.speedTo(1.0, duration: 0.5))
        } else if score >= 50 {
            obstacle1.runAction(SKAction.speedTo(0.9, duration: 0.5))
            obstacle2.runAction(SKAction.speedTo(0.9, duration: 0.5))
        } else if score >= 40 {
            obstacle1.runAction(SKAction.speedTo(0.8, duration: 0.5))
            obstacle2.runAction(SKAction.speedTo(0.8, duration: 0.5))
        } else if score >= 30 {
            obstacle1.runAction(SKAction.speedTo(0.7, duration: 0.5))
            obstacle2.runAction(SKAction.speedTo(0.7, duration: 0.5))
        } else if score >= 20 {
            obstacle1.runAction(SKAction.speedTo(0.6, duration: 0.5))
            obstacle2.runAction(SKAction.speedTo(0.6, duration: 0.5))
        } else if score >= 10 {
            obstacle1.runAction(SKAction.speedTo(0.5, duration: 0.5))
            obstacle2.runAction(SKAction.speedTo(0.5, duration: 0.5))
        }
    }
    
    func removeNodeWithExplosion(node: SKNode) {
        let ballPosition = node.position
        node.removeFromParent()
        
        let ballExplotion = SKEmitterNode(fileNamed: "BallExplode.sks")!
        ballExplotion.position = ballPosition
        self.addChild(ballExplotion)
        
        let explotionDuration = SKAction.waitForDuration(0.3)
        self.runAction(explotionDuration) {
            ballExplotion.numParticlesToEmit = 1
        }
    }
    
    func createBall() -> SKSpriteNode {
        let ball = SKSpriteNode(imageNamed: "Obstacle1Image")
        ball.position = CGPoint(x: 0, y: -200)
        ball.size = CGSize(width: 30, height: 30)
        ball.name = "Ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.categoryBitMask = BallCategory
        ball.physicsBody?.contactTestBitMask = ObstacleCategory
        ball.physicsBody?.collisionBitMask = 0x0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 350)
        return ball
    }
    
    func decrementLife() {
        livesLeft--
        let dissapearAction = SKAction.sequence([SKAction.scaleTo(0.1, duration: 0.3), SKAction.removeFromParent()])
        livesNodes[livesLeft].runAction(dissapearAction)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
