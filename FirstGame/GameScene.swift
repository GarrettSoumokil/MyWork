//
//  GameScene.swift
//  FirstGame
//
//  Created by Garrett Soumokil on 3/2/16.
//  Copyright (c) 2016 Garrett Soumokil. All rights reserved.
//

import SpriteKit
import GameKit

// structure for physics properties
struct Physics {
    static let Man: UInt32 = 0x1 << 1
    static let Money: UInt32 = 0x1 << 2
    static let Bomb: UInt32 = 0x1 << 3
    static let BombBig: UInt32 = 0x1 << 4
    static let MoneyBag: UInt32 = 0x1 << 5
    static let WireCutter: UInt32 = 0x1 << 6
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //setting up sprites
    let player = SKSpriteNode(imageNamed: "MoneyMan")
    let background = SKSpriteNode(imageNamed: "silverBack")
    // add sound effects
    let moneySound = SKAction.playSoundFileNamed("Moneybags.mp3", waitForCompletion: false)
    let bombSound = SKAction.playSoundFileNamed("bombExplosion.wav", waitForCompletion: false)
    let cuttingSound = SKAction.playSoundFileNamed("cuttingSound.wav", waitForCompletion: false)
    let backgroundMusic = SKAudioNode(fileNamed: "golucky.mp3")
    
    var gameStart = Bool()
    var score = Int()
    let scoreLabel = SKLabelNode()
    
    let gameOverLabel = SKLabelNode()
    
    var dead = Bool()
    var restartBtn = SKSpriteNode()
    let restartLabel = SKLabelNode()
    
    var pause = Bool()
    var pauseBtn = SKLabelNode()
    let pauseLabel = SKLabelNode()
    
    var homeLabel = SKLabelNode()
    let highScoreLabel = SKLabelNode()
    var highScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
    
    var totalMoneyBags = Double()
    var totalDollars = Double()
    
    var gameCenterAchievements = [String: GKAchievement]()

    
    // textures for animation
    let textureAtlas = SKTextureAtlas(named: "Explosions")
    var explodeArray = [SKTexture]()
    var explodeSprite = SKSpriteNode()
    
    // function called when restart button clicked
    func restartGame(){
        
        self.removeAllChildren()
        self.removeAllActions()
        dead = false
        gameStart = false
        pauseBtn.hidden = false
        score = 0
        createGame()
    }
    
    // function to create game. took code from didMoveToView
    func createGame(){
        // sets border frame for physics
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = borderBody
        self.physicsBody?.friction = 0
        self.physicsWorld.contactDelegate = self
        
        scoreLabel.position = CGPoint(x: self.frame.width / 1.1, y: self.frame.height / 10)
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 10
        scoreLabel.fontName = "04b_19"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.blueColor()
        addChild(scoreLabel)
        
        pauseBtn.name = "PauseBtn"
        pauseBtn.position = CGPoint(x: self.frame.width / 1.1, y: self.frame.height / 1.2)
        pauseBtn.zPosition = 10
        pauseBtn.fontSize = 50
        pauseBtn.fontName = "04b_19"
        pauseBtn.text = "II"
        pauseBtn.fontColor = SKColor.blueColor()
        pauseBtn.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        addChild(pauseBtn)
        
        pauseLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.5)
        pauseLabel.text = "PAUSED"
        pauseLabel.zPosition = 20
        pauseLabel.fontName = "04b_19"
        pauseLabel.fontSize = 70
        pauseLabel.fontColor = SKColor.blueColor()
        pauseLabel.runAction(SKAction.scaleTo(1.0, duration: 0.3))
        addChild(pauseLabel)
        pauseLabel.hidden = true
        
        // sets background size and position
        background.position = CGPointMake(self.size.width/2, self.size.height/2)
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.zPosition = 0
        addChild(background)
        
        // adding sprite properties
        player.name = "Player"
        player.setScale(0.3)
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.height / 2)
        player.physicsBody?.categoryBitMask = Physics.Man
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.contactTestBitMask = Physics.Money | Physics.Bomb | Physics.MoneyBag | Physics.WireCutter | Physics.BombBig
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        addChild(player)
        
        // adding textures to array atlas
        explodeArray.append(textureAtlas.textureNamed("explosion0"))
        explodeArray.append(textureAtlas.textureNamed("explosion1"))
        explodeArray.append(textureAtlas.textureNamed("explosion2"))
        explodeSprite = SKSpriteNode(imageNamed: textureAtlas.textureNames[0])
        explodeSprite.size = CGSize(width: 400, height: 400)
        explodeSprite.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        explodeSprite.zPosition = 5
        //addChild(explodeSprite)
        
        pause = false
        
        self.gameCenterAchievements.removeAll()
        self.loadAchievementPercentages()
        
        // adds background music
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)

    }
    
    override func didMoveToView(view: SKView) {
        createGame()
    }
    
    // function to create random integers used later
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    // function for adding in cash sprite, placing sprite and randomizing speeds
    func addCash() {
        // create cash sprite
        let cash = SKSpriteNode(imageNamed: "Dollar")
        // determine where to place money
        let trueY = random(min: cash.size.height/2, max: size.height - cash.size.height/2)
        
        // place cash slightly off screen and add size properties
        cash.name = "Cash"
        cash.setScale(2)
        cash.zPosition = 1
        cash.position = CGPoint(x: size.width + cash.size.width/2, y: trueY)
        
        // add physics properties to cash
        cash.physicsBody = SKPhysicsBody(rectangleOfSize: cash.size)
        cash.physicsBody?.categoryBitMask = Physics.Money
        cash.physicsBody?.collisionBitMask = 0 //Physics.Man
        cash.physicsBody?.contactTestBitMask = Physics.Man
        cash.physicsBody?.dynamic = false
        
        // add cash sprite
        addChild(cash)
        
        // determine speed of cash
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        // create movement actions
        let actionMove = SKAction.moveTo(CGPoint(x: -cash.size.width/2, y: trueY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        cash.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // function for adding in money bag sprite, placing sprite and randomizing speeds
    func addMoneyBag() {
        // create cash sprite
        let cash = SKSpriteNode(imageNamed: "MoneyBag")
        // determine where to place money
        let trueY = random(min: cash.size.height/2, max: size.height - cash.size.height/2)
        
        // place cash slightly off screen and add size properties
        cash.name = "Cash"
        cash.setScale(0.5)
        cash.zPosition = 1
        cash.position = CGPoint(x: size.width + cash.size.width/2, y: trueY)
        
        // add physics properties to cash
        cash.physicsBody = SKPhysicsBody(rectangleOfSize: cash.size)
        cash.physicsBody?.categoryBitMask = Physics.MoneyBag
        cash.physicsBody?.collisionBitMask = 0 //Physics.Man
        cash.physicsBody?.contactTestBitMask = Physics.Man
        cash.physicsBody?.dynamic = false
        
        // add cash sprite
        addChild(cash)
        
        // determine speed of cash
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        // create movement actions
        let actionMove = SKAction.moveTo(CGPoint(x: -cash.size.width/2, y: trueY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        cash.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }

    
    // function for adding in bomb sprite, placing sprite and randomzing speeds
    func addBomb() {
        // create bomb sprite
        let bomb = SKSpriteNode(imageNamed: "Bomb")
        // determine where to place bomb
        let trueY = random(min: 0, max: size.height )//- bomb.size.height/2)
        
        // place bomb slightly off screen and add size properties
        bomb.name = "Bomb"
        bomb.setScale(0.3)
        bomb.zPosition = 1
        bomb.position = CGPoint(x: size.width + bomb.size.width/2, y: trueY)
        
        // add physics properties to bomb
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.frame.height/2)
        bomb.physicsBody?.categoryBitMask = Physics.Bomb
        bomb.physicsBody?.collisionBitMask = 0//Physics.Man
        bomb.physicsBody?.contactTestBitMask = Physics.Man
        bomb.physicsBody?.dynamic = false
        
        addChild(bomb)
        
        // determine speed of bomb
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(4.5))
        // create movement actions
        let actionMove = SKAction.moveTo(CGPoint(x: -bomb.size.width/2, y: trueY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        bomb.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // function for adding in Big Bomb sprite, placing sprite and randomizing speeds
    func addBombBig() {
        // create bomb sprite
        let bomb = SKSpriteNode(imageNamed: "Bomb")
        // determine where to place bomb
        let trueY = random(min: 0, max: size.height )//- bomb.size.height/2)
        
        // place bomb slightly off screen and add size properties
        bomb.name = "BombBig"
        bomb.setScale(0.6)
        bomb.zPosition = 1
        bomb.position = CGPoint(x: size.width + bomb.size.width/2, y: trueY)
        
        // add physics properties to bomb
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.frame.height/2)
        bomb.physicsBody?.categoryBitMask = Physics.BombBig
        bomb.physicsBody?.collisionBitMask = 0//Physics.Man
        bomb.physicsBody?.contactTestBitMask = Physics.Man
        bomb.physicsBody?.dynamic = false
        
        addChild(bomb)
        
        // determine speed of bomb
        let actualDuration = random(min: CGFloat(5.0), max: CGFloat(6.0))
        // create movement actions
        let actionMove = SKAction.moveTo(CGPoint(x: -bomb.size.width/2, y: trueY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        bomb.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // function for adding in wire cutter sprite, placing sprite and randomizing speeds
    func addCutters() {
        // create bomb sprite
        let cutters = SKSpriteNode(imageNamed: "WireCutters")
        // determine where to place bomb
        let trueY = random(min: 0, max: size.height )//- bomb.size.height/2)
        
        // place bomb slightly off screen and add size properties
        cutters.name = "WireCutters"
        cutters.setScale(0.6)
        cutters.zPosition = 1
        cutters.position = CGPoint(x: size.width + cutters.size.width/2, y: trueY)
        
        // add physics properties to bomb
        cutters.physicsBody = SKPhysicsBody(circleOfRadius: cutters.frame.height/2)
        cutters.physicsBody?.categoryBitMask = Physics.WireCutter
        cutters.physicsBody?.collisionBitMask = 0//Physics.Man
        cutters.physicsBody?.contactTestBitMask = Physics.Man
        cutters.physicsBody?.dynamic = false
        
        addChild(cutters)
        
        // determine speed of cutters
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(4.0))
        // create movement actions
        let actionMove = SKAction.moveTo(CGPoint(x: -cutters.size.width/2, y: trueY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        cutters.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // if game is not started, initializes run actions for game
        let dollarTime = random(min: CGFloat(1.1), max: CGFloat(2.0))
        let bagTime = random(min: CGFloat(10.0), max: CGFloat(14.0))
        let bombTime = random(min: CGFloat(1.0), max: CGFloat(1.5))
        let bigBombTime = random(min: CGFloat(8.0), max: CGFloat(15.0))
        let cuttersTime = random(min: CGFloat(23.0), max: CGFloat(30.0))
        
        if gameStart == false {
            // game wont start will first tap
            gameStart = true
            player.physicsBody?.affectedByGravity = true
            print("GAMESTART")
                // runAction for addCash function
            runAction(SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.runBlock(addCash),
                    SKAction.waitForDuration(NSTimeInterval(dollarTime))
                    ])
                ))
                // runAction for addBomb function
            runAction(SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.runBlock(addBomb),
                    SKAction.waitForDuration(NSTimeInterval(bombTime))
                    ])
                ))
                // runAction for addMoneyBag function
            runAction(SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.waitForDuration(NSTimeInterval(bagTime)),
                    SKAction.runBlock(addMoneyBag)
                    
                    ])
                ))
                // runAction for addBigBomb function
            runAction(SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.waitForDuration(NSTimeInterval(bigBombTime)),
                    SKAction.runBlock(addBombBig)
                    ])
                ))
                // runAction for addCutters function
            runAction(SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.waitForDuration(NSTimeInterval(cuttersTime)),
                    SKAction.runBlock(addCutters)
                    ])
                ))
            
            // movement of player sprite upon tapping screen
            player.physicsBody?.velocity = CGVectorMake(0, 0)
            player.physicsBody?.applyImpulse(CGVectorMake(0, 51))

        } else {
            
            player.physicsBody?.velocity = CGVectorMake(0, 0)
            player.physicsBody?.applyImpulse(CGVectorMake(0, 51))
        }
        
        for touch in (touches){
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if (touchedNode.name == "PauseBtn"){
                pauseGame()
            }
            
            if dead == true{
                if restartBtn.containsPoint(location){
                    restartGame()
                } else if touchedNode.name == "HomeLabel" {
                    backgroundMusic.removeFromParent()
                    let scene = MainMenuScene(size: self.size)
                    self.view?.presentScene(scene) //, transition: SKTransition.crossFadeWithDuration(1.0))
                }
            }
            
        }
        
    }
    
    // pause game function
    func pauseGame() {
        if pause == false {
            print("Game Paused")
            pause = true
            self.speed = 0
            self.physicsWorld.speed = 0
            //backgroundMusic.runAction(SKAction.pause())
            pauseLabel.hidden = false
        } else {
            print("Game Resumed")
            pause = false
            self.speed = 1
            self.physicsWorld.speed = 1
            // on exiting pause music sometimes doesnt play and lags game
            //backgroundMusic.runAction(SKAction.play())
            pauseLabel.hidden = true
        }

    }
    
    // function for colliding with dollar sprite. removes money and plays sound
    func getDollar(money:SKSpriteNode, player:SKSpriteNode) {
        score += 1
        scoreLabel.text = "\(score)"
        money.removeFromParent()
        runAction(moneySound)
    }
    // function for colliding with moneybag sprite. removes money and plays sound
    func getMoneyBag(money:SKSpriteNode, player:SKSpriteNode) {
        score+=3
        scoreLabel.text = "\(score)"
        totalMoneyBags+=1
        money.removeFromParent()
        runAction(moneySound)
    }
    // function for removing bombs upon collision. loops through children for nodes with names
    func cutWires(wires:SKSpriteNode, player:SKSpriteNode){
        for _ in self.children {
            childNodeWithName("Bomb")?.removeFromParent()
            childNodeWithName("BombBig")?.removeFromParent()
            childNodeWithName("WireCutters")?.removeFromParent()
        }
        // must be player to remove wire cutters. not sure why
        runAction(cuttingSound)
    }
    
    // function for colliding with bomb sprite. removes bomb
    // makes player dead. adds restart button to scene
    func bombExplode(bomb:SKSpriteNode, player:SKSpriteNode) {
        print("DEAD")
        addChild(explodeSprite)
        explodeSprite.runAction(SKAction.sequence([SKAction.animateWithTextures(explodeArray, timePerFrame: 0.02), SKAction.removeFromParent()]))
        bomb.removeFromParent()
        dead = true
    }
    
    // function for creating a restart button upon death
    func createRestart(){
        //restartBtn = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: 200, height: 50))
        restartBtn.size = CGSize(width: 200, height: 50)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 15)
        restartBtn.zPosition = 10
        restartBtn.setScale(0)
        addChild(restartBtn)
        restartBtn.runAction(SKAction.scaleTo(1.0, duration: 0.3))
        
        restartLabel.position = CGPointMake(self.frame.width / 2, self.frame.height * 0.45)
        restartLabel.zPosition = 11
        restartLabel.text = "RESTART?"
        restartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        restartLabel.name = "RestartLabel"
        restartLabel.fontSize = 40
        restartLabel.fontName = "04b_19"
        restartLabel.fontColor = SKColor.blueColor()
        addChild(restartLabel)
        restartLabel.runAction(SKAction.scaleTo(1.0, duration: 0.1))
        
        gameOverLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.3)
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.zPosition = 10
        gameOverLabel.fontName = "04b_19"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = SKColor.blueColor()
        addChild(gameOverLabel)
        gameOverLabel.runAction(SKAction.scaleTo(1.0, duration: 0.3))
        
        homeLabel.position = CGPointMake(self.frame.width / 2, self.frame.height * 0.3)
        homeLabel.zPosition = 11
        homeLabel.text = "HOME"
        homeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        homeLabel.name = "HomeLabel"
        homeLabel.fontSize = 40
        homeLabel.fontName = "04b_19"
        homeLabel.fontColor = SKColor.blueColor()
        addChild(homeLabel)
        homeLabel.runAction(SKAction.scaleTo(1.0, duration: 0.1))
        
        highScoreLabel.text = ""
        highScoreLabel.fontSize = 45
        highScoreLabel.fontName = "04b_19"
        highScoreLabel.fontColor = SKColor.redColor()
        highScoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 1.6)
        highScoreLabel.zPosition = 11
        addChild(highScoreLabel)
        
        pauseBtn.hidden = true
        
        checkTenDollars()
        checkFiveMoneyBags()
        checkTotalDollars()
        
        if (score > highScore) {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            highScoreLabel.text = "NEW High Score: \(score)!"
            saveHighscore(score)
        } else {
            highScoreLabel.text = "High Score : \(highScore)"
        }
        
    }
 

    // function for when contact between to sprites occurs
    func didBeginContact(contact: SKPhysicsContact) {
        // sets up two contact bodies
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        // if else for sprite categorys making contact and runs function
        if firstBody.categoryBitMask == Physics.Money && secondBody.categoryBitMask == Physics.Man ||
            firstBody.categoryBitMask == Physics.Man && secondBody.categoryBitMask == Physics.Money
        {
            getDollar(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == Physics.MoneyBag && secondBody.categoryBitMask == Physics.Man ||
            firstBody.categoryBitMask == Physics.Man && secondBody.categoryBitMask == Physics.MoneyBag
        {
            getMoneyBag(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == Physics.WireCutter && secondBody.categoryBitMask == Physics.Man ||
            firstBody.categoryBitMask == Physics.Man && secondBody.categoryBitMask == Physics.WireCutter
        {
            cutWires(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
        }
        else if firstBody.categoryBitMask == Physics.Bomb && secondBody.categoryBitMask == Physics.Man ||
            firstBody.categoryBitMask == Physics.Man && secondBody.categoryBitMask == Physics.Bomb
        {
            // bombExplode function runs. removes player sprite
            // stops all other sprites as game ends
            enumerateChildNodesWithName("//*" , usingBlock: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
                
            }))
            bombExplode(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
            player.removeFromParent()
            // sound must be played after removeAllActions
            runAction(bombSound)
            SKAction.waitForDuration(3.0)
            print("Death by little bomb")
            createRestart()
            
        } else if firstBody.categoryBitMask == Physics.BombBig && secondBody.categoryBitMask == Physics.Man ||
            firstBody.categoryBitMask == Physics.Man && secondBody.categoryBitMask == Physics.BombBig
        {
            // bombExplode function runs. removes player sprite
            // stops all other sprites as game ends
            enumerateChildNodesWithName("//*" , usingBlock: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
                
            }))
            bombExplode(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
            player.removeFromParent()
            // sound must be played after removeAllActions
            runAction(bombSound)
            SKAction.waitForDuration(3.0)
            print("Death by big bomb")
            createRestart()
            checkBigBomb()
        }


    }
    
    
    // function to save high score to leaderboards
    func saveHighscore(score:Int){
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: "GTM.HighScore")
            scoreReporter.value = Int64(self.score)
            let scoreArray: [GKScore] = [scoreReporter]
            print("report score \(scoreReporter)")
            GKScore.reportScores(scoreArray, withCompletionHandler: {error -> Void in
                if error != nil {
                    print("An error has occured: \(error)")
                }
            })
        }
    }
    
    
    func checkTenDollars() {
        if GKLocalPlayer.localPlayer().authenticated {
            // check if they earned 10 dollars
            if self.score >= 10 {
                let achieve = GKAchievement(identifier: "GTM.10Dollars")
                //notification of achievement 
                achieve.showsCompletionBanner = true
                achieve.percentComplete = 100
                // report achievement
                GKAchievement.reportAchievements([achieve], withCompletionHandler:{error -> Void in
                    if error != nil {
                        print("An error has occured: \(error)")
                    }
                })
            }
        }
    }
    
    func checkFiveMoneyBags() {
        if GKLocalPlayer.localPlayer().authenticated {
            // check if they earned 5 Money Bags
            let achieve = GKAchievement(identifier: "GTM.5MoneyBags")
            var bagProgess = Double()
            if self.totalMoneyBags >= 5 {
                //notification of achievement
                achieve.showsCompletionBanner = true
                achieve.percentComplete = 100
                // report achievement
                GKAchievement.reportAchievements([achieve], withCompletionHandler:{error -> Void in
                    if error != nil {
                        print("An error has occured: \(error)")
                    }
                })
            } else {
                //notification of achievement
                bagProgess = (totalMoneyBags/5.0)*100
                achieve.showsCompletionBanner = false
                achieve.percentComplete = bagProgess
                // report achievement
                print("Bag progress is \(bagProgess) percent")
                GKAchievement.reportAchievements([achieve], withCompletionHandler:{error -> Void in
                    if error != nil {
                        print("An error has occured: \(error)")
                    }
                })
            }
        }
    }
    
    func checkBigBomb(){
        if GKLocalPlayer.localPlayer().authenticated {
            let achieve = GKAchievement(identifier: "GTM.BigBomb")
            achieve.showsCompletionBanner = true
            achieve.percentComplete = 100
            // report achievement
            GKAchievement.reportAchievements([achieve], withCompletionHandler:{error -> Void in
                if error != nil {
                    print("An error has occured: \(error)")
                }
            })
        }
    }
    
    func checkTotalDollars() {
        if GKLocalPlayer.localPlayer().authenticated {
           
            totalDollars = Double(score)
            let progress = (totalDollars/500)*100
            
            let achieve = GKAchievement(identifier: "GTM.500Dollars")
            print("Current percent completed \(achieve.percentComplete) %")
            if (achieve.percentComplete < 100) {
                print("Gained \(progress) percent")
                //achieve.percentComplete += progress as Double
                incrementCurrentPercentOfAchievement("GTM.500Dollars", amount: progress)
                
//                GKAchievement.reportAchievements([achieve], withCompletionHandler:{error -> Void in
//                    if error != nil {
//                        print("An error has occured: \(error)")
//                    }
//                })
                print("Total percent progress towards 500 is \(achieve.percentComplete) %")
                if (achieve.percentComplete == 100) {
                    achieve.percentComplete = 100
                    achieve.showsCompletionBanner = true
                    print("completed 500 dollar achievement")
                }
            }
            
        }
    }
    
    // loads current achivement percentages
    func loadAchievementPercentages() {
        print("Loading past achievement Percentages")
        
        GKAchievement.loadAchievementsWithCompletionHandler( { (allAchievements, error) -> Void in
            
            if error != nil {
                print("GC could not load achievements. Error: \(error)")
            } else {
                // nil if no progress on any achievements
                if (allAchievements != nil) {
                    for theAchievement in allAchievements! {
                        if let singleAchievement:GKAchievement = theAchievement {
                            
                            self.gameCenterAchievements[singleAchievement.identifier! ] = singleAchievement
                        }
                    }
                    
                    for (id, achievement) in self.gameCenterAchievements{
                        print(" \(id)   -   \(achievement.percentComplete)")
                    }
                }
            }
        })
    }
    // function to increase percentages 
    func incrementCurrentPercentOfAchievement(identifier:String, amount:Double) {
        if GKLocalPlayer.localPlayer().authenticated{
            var currentPercentFound:Bool = false
            if (gameCenterAchievements.count != 0) {
                for (id, achievement) in gameCenterAchievements {
                    if (id == identifier) {
                        currentPercentFound = true
                        
                        var currentPercent: Double = achievement.percentComplete
                        
                        currentPercent = currentPercent + amount
                        
                        reportAchievement(identifier, percentComplete:currentPercent)
                        
                        break
                    }
                    
                    
                }
            }
            
            if (currentPercentFound == false) {
                reportAchievement(identifier, percentComplete: amount)
            }
            
        }
    }
    
    func reportAchievement(identifier:String, percentComplete:Double){
        
        let achievement = GKAchievement(identifier: identifier)
        
        achievement.percentComplete = percentComplete
        
        let achievementArray:[GKAchievement] = [achievement]
        
        GKAchievement.reportAchievements(achievementArray, withCompletionHandler: {
            
            error -> Void in
            if (error != nil) {
                print(error)
            } else {
                
                print("reported achievement with percent complete of \(percentComplete)")
                
                self.gameCenterAchievements.removeAll()
                self.loadAchievementPercentages()
            }
            
            
        })
        
        
    }

    

}
