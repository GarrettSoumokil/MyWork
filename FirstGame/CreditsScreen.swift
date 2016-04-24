//
//  CreditsScreen.swift
//  FirstGame
//
//  Created by Garrett Soumokil on 3/24/16.
//  Copyright © 2016 Garrett Soumokil. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class CreditsScreen: SKScene {
    
    let backgroundMusic = SKAudioNode(fileNamed: "golucky.mp3")
    let background = SKSpriteNode(imageNamed: "silverBack")
    let titleLabel = SKLabelNode()
    let homeLabel = SKLabelNode()
    let creatorLabel = SKLabelNode()
    let sourceLabel = SKLabelNode()
    let thanksLabel = SKLabelNode()
    
    
    override func didMoveToView(view: SKView) {
        let viewSize: CGSize = view.bounds.size
        background.position = CGPoint(x: viewSize.width/2, y: viewSize.height/2)
        background.zPosition = 0
        addChild(background)
        
        titleLabel.text = "CREDITS"
        titleLabel.fontSize = 65
        titleLabel.fontName = "04b_19"
        titleLabel.fontColor = SKColor.redColor()
        titleLabel.position = CGPoint(x: viewSize.width/2, y: viewSize.height * 0.75)
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
        
        creatorLabel.text = "Created by G$ Games"
        creatorLabel.position = CGPointMake(viewSize.width/2, self.frame.height * 0.6)
        creatorLabel.zPosition = 11
        creatorLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        creatorLabel.fontSize = 20
        creatorLabel.fontName = "04b_19"
        creatorLabel.fontColor = SKColor.blueColor()
        addChild(creatorLabel)
        
        sourceLabel.text = "All images either self created or found within GameArt.org"
        sourceLabel.position = CGPointMake(viewSize.width/2, self.frame.height * 0.4)
        sourceLabel.zPosition = 11
        sourceLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        sourceLabel.fontSize = 20
        sourceLabel.fontName = "04b_19"
        sourceLabel.fontColor = SKColor.blueColor()
        addChild(sourceLabel)
        
        thanksLabel.text = "Special thanks to Joshua Shroyer @ Full Sail University"
        thanksLabel.position = CGPointMake(viewSize.width/2, self.frame.height * 0.2)
        thanksLabel.zPosition = 11
        thanksLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        thanksLabel.fontSize = 20
        thanksLabel.fontName = "04b_19"
        thanksLabel.fontColor = SKColor.blueColor()
        addChild(thanksLabel)
        

        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
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
