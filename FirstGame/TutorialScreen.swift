//
//  TutorialScreen.swift
//  FirstGame
//
//  Created by Garrett Soumokil on 3/24/16.
//  Copyright © 2016 Garrett Soumokil. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialScreen: SKScene, SKPhysicsContactDelegate {
    
    let backgroundMusic = SKAudioNode(fileNamed: "golucky.mp3")
    let background = SKSpriteNode(imageNamed: "silverBack")
    let titleLabel = SKLabelNode()
    let homeLabel = SKLabelNode()
    let player = SKSpriteNode(imageNamed: "MoneyMan")
    var playerLabel = SKLabelNode()
    let bomb = SKSpriteNode(imageNamed: "Bomb")
    let bombLabel = SKLabelNode()
    let cash = SKSpriteNode(imageNamed: "Dollar")
    let cashLabel = SKLabelNode()
    let wireCutters = SKSpriteNode(imageNamed: "WireCutters")
    let wireLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = borderBody
        self.physicsBody?.friction = 0
        self.physicsWorld.contactDelegate = self
        
        let viewSize: CGSize = view.bounds.size
        background.position = CGPoint(x: viewSize.width/2, y: viewSize.height/2)
        background.zPosition = 0
        addChild(background)
        
        titleLabel.text = "TUTORIAL"
        titleLabel.fontSize = 65
        titleLabel.fontName = "04b_19"
        titleLabel.fontColor = SKColor.redColor()
        titleLabel.position = CGPoint(x: viewSize.width/2, y: viewSize.height * 0.8)
        titleLabel.zPosition = 1
        addChild(titleLabel)
        
        homeLabel.position = CGPointMake(self.frame.width * 0.1, self.frame.height * 0.85)
        homeLabel.zPosition = 11
        homeLabel.text = "HOME"
        homeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        homeLabel.name = "HomeLabel"
        homeLabel.fontSize = 40
        homeLabel.fontName = "04b_19"
        homeLabel.fontColor = SKColor.blueColor()
        addChild(homeLabel)
        homeLabel.runAction(SKAction.scaleTo(1.0, duration: 0.1))
        
        player.setScale(0.3)
        player.position = CGPoint(x: viewSize.width * 0.15, y: size.height * 0.5)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.height / 2)
        player.physicsBody?.categoryBitMask = Physics.Man
        player.physicsBody?.collisionBitMask = 1
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.dynamic = true
        player.physicsBody?.allowsRotation = false
        addChild(player)
        
        playerLabel.text = "Tap to go up"
        playerLabel.fontSize = 30
        playerLabel.fontName = "04b_19"
        playerLabel.fontColor = SKColor.blueColor()
        playerLabel.position = CGPoint(x: viewSize.width * 0.2, y: viewSize.height * 0.33)
        playerLabel.zPosition = 1
        addChild(playerLabel)
        
        cash.setScale(2)
        cash.zPosition = 1
        cash.position = CGPoint(x: viewSize.width * 0.85, y: size.height * 0.85)
        addChild(cash)
        
        cashLabel.text = "Get the $$$"
        cashLabel.fontSize = 25
        cashLabel.fontName = "04b_19"
        cashLabel.fontColor = SKColor.blueColor()
        cashLabel.position = CGPoint(x: viewSize.width * 0.85, y: viewSize.height * 0.7)
        cashLabel.zPosition = 1
        addChild(cashLabel)
        
        bomb.setScale(0.3)
        bomb.zPosition = 1
        bomb.position = CGPoint(x: viewSize.width * 0.85, y: size.height * 0.55)
        addChild(bomb)
        
        bombLabel.text = "Avoid Bombs"
        bombLabel.fontSize = 25
        bombLabel.fontName = "04b_19"
        bombLabel.fontColor = SKColor.blueColor()
        bombLabel.position = CGPoint(x: viewSize.width * 0.85, y: viewSize.height * 0.4)
        bombLabel.zPosition = 1
        addChild(bombLabel)
        
        wireCutters.setScale(0.6)
        wireCutters.zPosition = 1
        wireCutters.position = CGPoint(x: viewSize.width * 0.85, y: size.height * 0.25)
        addChild(wireCutters)
        
        wireLabel.text = "Cutters Defuse Bombs"
        wireLabel.fontSize = 25
        wireLabel.fontName = "04b_19"
        wireLabel.fontColor = SKColor.blueColor()
        wireLabel.position = CGPoint(x: viewSize.width * 0.75, y: size.height * 0.09)
        wireLabel.zPosition = 1
        addChild(wireLabel)
        
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.velocity = CGVectorMake(0, 0)
        player.physicsBody?.applyImpulse(CGVectorMake(0, 60))
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if (touchedNode.name == "HomeLabel") {
                backgroundMusic.removeFromParent()
                let scene = MainMenuScene(size: self.size)
                self.view?.presentScene(scene) //, transition: SKTransition.crossFadeWithDuration(2.0))
            }
            
        }
    }
}
