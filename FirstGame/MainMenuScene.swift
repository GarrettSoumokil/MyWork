//
//  MainMenuScene.swift
//  FirstGame
//
//  Created by Garrett Soumokil on 3/24/16.
//  Copyright © 2016 Garrett Soumokil. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    let backgroundMusic = SKAudioNode(fileNamed: "golucky.mp3")
    let background = SKSpriteNode(imageNamed: "silverBack")
    let titleLabel = SKLabelNode()
    let playBtn = SKSpriteNode(imageNamed: "PlayButton")
    let creditsLabel = SKLabelNode()
    let tutorialLabel = SKLabelNode()
    let highScoreLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        let viewSize: CGSize = view.bounds.size
        background.position = CGPoint(x: viewSize.width/2, y: viewSize.height/2)
        background.zPosition = 0
        addChild(background)
        
        titleLabel.text = "Get The Money"
        titleLabel.fontSize = 65
        titleLabel.fontName = "04b_19"
        titleLabel.fontColor = SKColor.blueColor()
        titleLabel.position = CGPoint(x: viewSize.width/2, y: viewSize.height * 0.75)
        titleLabel.zPosition = 1
        addChild(titleLabel)
        
        playBtn.name = "playBtn"
        playBtn.setScale(1.1)
        playBtn.position = CGPoint(x: viewSize.width/2, y: viewSize.height * 0.55)
        playBtn.zPosition = 2
        addChild(playBtn)
        
        creditsLabel.position = CGPointMake(self.frame.width * 0.25, self.frame.height * 0.15)
        creditsLabel.zPosition = 11
        creditsLabel.text = "CREDITS"
        creditsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        creditsLabel.name = "creditsLabel"
        creditsLabel.fontSize = 40
        creditsLabel.fontName = "04b_19"
        creditsLabel.fontColor = SKColor.blueColor()
        addChild(creditsLabel)
        creditsLabel.runAction(SKAction.scaleTo(1.0, duration: 0.1))
        
        tutorialLabel.position = CGPointMake(self.frame.width * 0.75, self.frame.height * 0.15)
        tutorialLabel.zPosition = 11
        tutorialLabel.text = "HOW TO PLAY"
        tutorialLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        tutorialLabel.name = "tutorialLabel"
        tutorialLabel.fontSize = 40
        tutorialLabel.fontName = "04b_19"
        tutorialLabel.fontColor = SKColor.blueColor()
        addChild(tutorialLabel)
        tutorialLabel.runAction(SKAction.scaleTo(1.0, duration: 0.1))
        
        let highScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highScoreLabel.text = "Current High Score: \(highScore)"
        highScoreLabel.position = CGPoint(x: viewSize.width * 0.5, y: viewSize.height * 0.3)
        highScoreLabel.zPosition = 11
        highScoreLabel.fontSize = 40
        highScoreLabel.fontName = "04b_19"
        highScoreLabel.fontColor = SKColor.redColor()
        addChild(highScoreLabel)
        
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if (touchedNode.name == "playBtn") {
                backgroundMusic.removeFromParent()
                let scene = GameScene(size: self.size)
                self.view?.presentScene(scene) //, transition: SKTransition.crossFadeWithDuration(1.0))
            } else if (touchedNode.name == "creditsLabel"){
                backgroundMusic.removeFromParent()
                let scene = CreditsScreen(size: self.size)
                self.view?.presentScene(scene) // , transition: SKTransition.crossFadeWithDuration(1.0))
            } else if (touchedNode.name == "tutorialLabel"){
                backgroundMusic.removeFromParent()
                let scene = TutorialScreen(size: self.size)
                self.view?.presentScene(scene) //, transition: SKTransition.crossFadeWithDuration(1.0))
            }
            
        }
    }
}
