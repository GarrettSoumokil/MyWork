//
//  GameViewController.swift
//  FirstGame
//
//  Created by Garrett Soumokil on 3/2/16.
//  Copyright (c) 2016 Garrett Soumokil. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController{

    var localPlayer = GKLocalPlayer.localPlayer()
    var gcEnabled = Bool() // checks if Game Center is enabled
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authenticatePlayer()
       // if let scene = GameScene(fileNamed:"GameScene") {
        let scene = MainMenuScene(size: view.bounds.size)
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            //scene.scaleMode = .ResizeFill
            scene.scaleMode = .Fill
            scene.size = self.view.bounds.size
            //skView.showsPhysics = true
            skView.presentScene(scene)
    //    }
    }

    
    override func viewDidAppear(animated: Bool) {
        authenticatePlayer()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func authenticatePlayer() {
            // Assigning a block to the localPlayer's
            // authenticateHandler kicks off the process
            // of authenticating the user with Game Center.
                localPlayer.authenticateHandler = { (viewController, error) in
                    if viewController != nil {
                        self.presentViewController(viewController!,animated: true, completion: nil)
    
                    } else if self.localPlayer.authenticated {
                        // authenticated, and can now use Game Center features
                        print("Authenticated!")
                        self.gcEnabled = true
                        
                    } else {
                        // not authenticated.
                        print("Local player could not be authenticated.")
                        print("Error! \(error)")
                        self.gcEnabled = false
                }
            }
    }
    
}
