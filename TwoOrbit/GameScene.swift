//
//  GameScene.swift
//  TwoOrbit
//
//  Created by Jung Woo Kim on 8/17/15.
//  Copyright (c) 2015 Jung Woo Kim. All rights reserved.
//

import SpriteKit
import GameKit

protocol GameSceneDelegate {
    func didRequestGameCenter()
}

class GameScene: SKScene, SKPhysicsContactDelegate, OverlaySceneDelegate {
    let BallCategory: UInt32 = 0x1 << 0
    let ObstacleCategory: UInt32 = 0x1 << 1
    let TargetCategory: UInt32 = 0x1 << 2
    
    enum GameState {
        case WaitingForPlay, Playing, GameOver, Menu, Help, Pause
    }
    var gameState: GameState!
    var sceneDelegate: GameSceneDelegate?
    
    var gameOverScene: GameOverScene!
    var menuScene: MenuScene!
    var howToPlayScene: HowToPlayScene!
    var pauseScene: PauseScene!
    
    var obstacle1: SKSpriteNode!
    var obs1Move: SKAction!
    var obstacle2: SKSpriteNode!
    var obs2Move: SKAction!
    var obstacle3: SKSpriteNode!
    var obs3Move: SKAction!
    var target: SKSpriteNode!
    
    var livesLeft = 5
    var score = 0
    var livesNodes: [SKSpriteNode]!
    var scoreLabel: SKLabelNode!
    var tapToBeginText: SKLabelNode!
    var pauseButton: SKSpriteNode!
    
    var animateIn: SKAction!
    var animateOut: SKAction!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.whiteColor()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        gameState = .Menu
        
        // Actions
        animateIn = SKAction.fadeInWithDuration(0.3)
        animateOut = SKAction.fadeOutWithDuration(0.3)
        
        // UI initialization
        tapToBeginText = SKLabelNode(text: "Tap to begin")
        tapToBeginText.position = CGPoint(x: 0, y: 40)
        tapToBeginText.fontColor = UIColor.blackColor()
        tapToBeginText.fontSize = 30
        addChild(tapToBeginText)
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position = CGPoint(x: 0, y: size.height/2-60)
        scoreLabel.zPosition = 10
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.fontSize = 36
        addChild(scoreLabel)
        
        livesNodes = [SKSpriteNode]()
        for i in 0..<5 {
            let lifeNode = SKSpriteNode(imageNamed: "LifeImage")
            lifeNode.name = "Life"
            lifeNode.size = CGSize(width: 20, height: 20)
            lifeNode.position = CGPoint(x: -size.width/2 + CGFloat((i+1) * 22), y: size.height/2-100)
            livesNodes.append(lifeNode)
        }
        
        pauseButton = SKSpriteNode(imageNamed: "PauseIcon")
        pauseButton.size = CGSize(width: 35, height: 35)
        pauseButton.position = CGPoint(x: size.width/2-50, y: size.height/2-60)
        addChild(pauseButton)
        pauseButton.alpha = 0.0
        
        //Scenes
        gameOverScene = GameOverScene()
        gameOverScene.zPosition = 10
        gameOverScene.sceneDelegate = self
        addChild(gameOverScene)
        
        menuScene = MenuScene()
        menuScene.zPosition = 10
        menuScene.sceneDelegate = self
        addChild(menuScene)
        
        howToPlayScene = HowToPlayScene()
        howToPlayScene.zPosition = 10
        howToPlayScene.sceneDelegate = self
        howToPlayScene.alpha = 0.0
        addChild(howToPlayScene)
        
        pauseScene = PauseScene()
        pauseScene.zPosition = 10
        pauseScene.sceneDelegate = self
        pauseScene.alpha = 0.0
        addChild(pauseScene)
        
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
        emitterRed.zPosition = -10
        
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
        obs1Move = SKAction.repeatActionForever(followCircle)
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
        obs2Move = SKAction.repeatActionForever(followCircle2)
        obstacle2.runAction(obs2Move)
        
        obstacle3 = SKSpriteNode(imageNamed: "Obstacle3Image")
        obstacle3.size = CGSize(width: 30, height: 30)
        obstacle3.position = CGPoint(x: 120, y: 50)
        obstacle3.name = "Obstacle"
        obstacle3.alpha = 0.8
        obstacle3.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle3.size)
        obstacle3.physicsBody?.dynamic = false
        obstacle3.physicsBody?.categoryBitMask = ObstacleCategory
        obstacle3.physicsBody?.contactTestBitMask = BallCategory
        obstacle3.physicsBody?.collisionBitMask = 0x0
        //addChild(obstacle3)
        
        let moveAction1 = SKAction.moveToX(-120, duration: 1.3)
        let moveAction2 = SKAction.moveToX(120, duration: 1.3)
        let repeatMove = SKAction.repeatActionForever(SKAction.sequence([moveAction1, moveAction2]))
        obstacle3.runAction(repeatMove)
    }
    
    override func didMoveToView(view: SKView) {
        setupMenu()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenu() {
        gameOverScene.alpha = 0.0
        menuScene.alpha = 1.0
        pauseScene.alpha = 0.0
        pauseButton.alpha = 0.0
        
        tapToBeginText.alpha = 0.0
        scoreLabel.alpha = 0.0
        
        enumerateChildNodesWithName("Life") {
            (node: SKNode, stop: UnsafeMutablePointer<ObjCBool>) in
            node.removeFromParent()
        }
    }
    
    
    func startGame() {
        gameState = .WaitingForPlay
        
        tapToBeginText.runAction(animateIn)
        menuScene.runAction(animateOut)
        pauseButton.runAction(animateIn)
        enumerateChildNodesWithName("Life") {
            (node: SKNode, stop: UnsafeMutablePointer<ObjCBool>) in
            node.removeFromParent()
        }
        animateInLives()
        
        obstacle1.runAction(SKAction.speedTo(0.4, duration: 0.5))
        obstacle2.runAction(SKAction.speedTo(0.4, duration: 0.5))
        
        pauseScene.alpha = 0.0
        gameOverScene.alpha = 0.0
        scoreLabel.alpha = 0.0
        
        livesLeft = 5
        score = 0
        scoreLabel.text = "0"
    }
    
    func animateInLives() {
        for i in 0..<5 {
            livesNodes[i].xScale = 0.1
            livesNodes[i].yScale = 0.1
            addChild(livesNodes[i])
            let waitAndAnimate = SKAction.sequence([SKAction.waitForDuration(0.1*Double(i+1)), SKAction.scaleTo(1.0, duration: 0.2)])
            livesNodes[i].runAction(waitAndAnimate)
        }
    }
    
    func loadHighscore() {
        let highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        gameOverScene.highscoreLabel.text = "Best: \(highscore)"
    }
    
    func updateHighscore() {
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
    }
    
    // MARK: OverlaySceneDelegate methods
    func buttonTappedWithName(name: String) {
        if name == "ToHome" {
            gameState = .Menu
            setupMenu()
        } else if name == "Restart" {
            startGame()
        } else if name == "StartPlay" {
            startGame()
        } else if name == "GameCenter" {
            sceneDelegate?.didRequestGameCenter()
        } else if name == "Help" {
            gameState = .Help
            menuScene.alpha = 0.0
            howToPlayScene.alpha = 1.0
        } else if name == "CloseHelp" {
            gameState = .Menu
            howToPlayScene.alpha = 0.0
            menuScene.alpha = 1.0
        } else if name == "Continue" {
            gameState = .Playing
            pauseScene.alpha = 0.0
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameState == .GameOver {
            gameOverScene.touchesEnded(touches, withEvent: event)
            return
        } else if gameState == .Menu {
            menuScene.touchesEnded(touches, withEvent: event)
            return
        } else if gameState == .WaitingForPlay {
            gameState == .Playing
            tapToBeginText.runAction(animateOut) {
                self.scoreLabel.runAction(self.animateIn)
            }
        } else if gameState == .Help {
            howToPlayScene.touchesEnded(touches, withEvent: event)
            return
        } else if gameState == .Pause {
            pauseScene.touchesEnded(touches, withEvent: event)
            return
        }
        
        let location = touches.first!.locationInNode(self)
        if pauseButton.containsPoint(location) {
            gameState = .Pause
            pauseScene.alpha = 1.0
            
        } else {
            let toAddBall = newBall()
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
                removeNodeWithExplotion(ball)
                decrementLife()
            }
            
            if livesLeft <= 0 {
                userInteractionEnabled = false
                
                enumerateChildNodesWithName("Ball") {
                    (node: SKNode, stop: UnsafeMutablePointer<ObjCBool>) in
                    self.removeNodeWithExplotion(node)
                }
                
                gameOverScene.scoreLabel.text = "Score: \(score)"
                updateHighscore()
                loadHighscore()
                let sceneWaitAction = SKAction.waitForDuration(0.8)
                runAction(sceneWaitAction) {
                    let fadeInAction = SKAction.fadeInWithDuration(0.8)
                    self.gameOverScene.runAction(fadeInAction) {
                        self.userInteractionEnabled = true
                        self.gameState = .GameOver
                    }
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
    
    func removeNodeWithExplotion(node: SKNode) {
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
    
    func decrementLife() {
        livesLeft--
        let dissapearAction = SKAction.sequence([SKAction.scaleTo(0.1, duration: 0.3), SKAction.removeFromParent()])
        livesNodes[livesLeft].runAction(dissapearAction)
    }
    
    func newBall() -> SKSpriteNode {
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
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
