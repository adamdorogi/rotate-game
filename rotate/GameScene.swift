//
//  GameScene.swift
//  rotate
//
//  Created by Adam Dorogi-Kaposi on 23/04/2016.
//  Copyright (c) 2016 Adam Dorogi-Kaposi. All rights reserved.
//

import SpriteKit

// Create physics categories structure
struct physicsCategory {
    static let ball : UInt32 = 0x1 << 1
    static let cube : UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Declare variables
    var ball = SKSpriteNode()
    var cube = SKSpriteNode()
    var tapToPlay = SKSpriteNode()
    var gameOver = SKSpriteNode()
    var background = SKSpriteNode()
    // Buttons
    var playButton = SKSpriteNode()
    var backButton = SKSpriteNode()
    var gameCenterButton = SKSpriteNode()
    var rateButton = SKSpriteNode()
    var soundButton = SKSpriteNode()
    // Medals
    var goldMedal = SKSpriteNode()
    var platinumMedal = SKSpriteNode()
    var silverMedal = SKSpriteNode()
    var bronzeMedal = SKSpriteNode()
    
    var gameSceneStarted = Bool()
    
    var cubeSide = Int()
    var randomBallColor = Int()
    var randomBackground = Int()
    var score = Int()
    
    var gravity = CGFloat()
    var pixelScale = CGFloat()
    
    var ballColor = Array<String>()
    var backgroundImage = Array<String>()
    
    var scoreLabel = SKLabelNode()
    
    // Reset the ball
    func resetBall() {
        print("Ball has been reset.")
        
        // Remove ball from scene
        ball.removeFromParent()
        
        // Get random index from ballColor list
        randomBallColor = Int(arc4random_uniform(UInt32(ballColor.count)))
        // Set ball's image to random image picked from ballColor
        ball = SKSpriteNode(imageNamed: ballColor[randomBallColor])
        // Set ball's texture to random image picked from ballColor
        ball.texture = SKTexture(imageNamed: ballColor[randomBallColor])
        // Set ball's texture filtering mode to nearest neighbour
        ball.texture?.filteringMode = SKTextureFilteringMode.Nearest
        // Scale ball
        ball.setScale(pixelScale)
        // Set ball position
        ball.position = CGPoint(x: self.frame.width / 2, y: self.frame.height + ball.frame.height / 2)
        // Set ball z position
        ball.zPosition = 1
        // Reset ball velocity
        ball.physicsBody?.velocity = CGVectorMake(0, 0)
        // Reset ball rotation velocity
        ball.physicsBody?.angularVelocity = 0
        // Reset ball angle
        ball.zRotation = 0
        
        // Set ball's physics body
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2)
        // Set ball's physics category from structure
        ball.physicsBody?.categoryBitMask = physicsCategory.ball
        // Allow ball collision
        ball.physicsBody?.collisionBitMask = physicsCategory.ball
        // Allow ball to test collision with cube
        ball.physicsBody?.contactTestBitMask = physicsCategory.cube
        // Affect ball by gravity
        ball.physicsBody?.affectedByGravity = true
        // Allow ball to move
        ball.physicsBody?.dynamic = true
        
        // Add ball to scene
        self.addChild(ball)
    }
    
    // Reset the cube
    func resetCube() {
        print("Cube has been reset.")
        
        // Remove cube from scene
        cube.removeFromParent()
        
        // Set cube's image
        cube = SKSpriteNode(imageNamed: "cube")
        // Set cube's texture
        cube.texture = SKTexture(imageNamed: "cube")
        // Set cube's texture filtering mode to nearest neighbour
        cube.texture?.filteringMode = SKTextureFilteringMode.Nearest
        // Scale cube
        cube.setScale(pixelScale)
        // Set cube position
        cube.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4)
        // Set cube z position
        cube.zPosition = 2
        // Reset cube rotation velocity
        cube.physicsBody?.angularVelocity = 0
        // Reset cube angle
        cube.zRotation = 0
        
        // Set cube's physics body
        cube.physicsBody = SKPhysicsBody(rectangleOfSize: cube.size)
        // Set cube's physics category from structure
        cube.physicsBody?.categoryBitMask = physicsCategory.cube
        // Allow cube collision
        cube.physicsBody?.collisionBitMask = physicsCategory.cube
        // Allow cube to test collision with ball
        ball.physicsBody?.contactTestBitMask = physicsCategory.cube
        // Don't affect cube by gravity
        cube.physicsBody?.affectedByGravity = false
        // Don't allow cube to move (or be moved)
        cube.physicsBody?.dynamic = false
        
        // Add cube to scene
        self.addChild(cube)
    }
    
    // Create the menu
    func menuScene() {
        print("Menu has been reset.")
        
        // Create play button
        playButton.removeFromParent()
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.texture = SKTexture(imageNamed: "playButton")
        playButton.texture?.filteringMode = SKTextureFilteringMode.Nearest
        playButton.setScale(pixelScale)
        playButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        playButton.zPosition = 3
        self.addChild(playButton)
        
        // Create Game Center button
        gameCenterButton.removeFromParent()
        gameCenterButton = SKSpriteNode(imageNamed: "gameCenterButton")
        gameCenterButton.texture = SKTexture(imageNamed: "gameCenterButton")
        gameCenterButton.texture?.filteringMode = SKTextureFilteringMode.Nearest
        gameCenterButton.setScale(pixelScale)
        gameCenterButton.position = CGPoint(x: playButton.position.x - playButton.frame.width / 2 + gameCenterButton.frame.width / 2, y: playButton.position.y - playButton.frame.height / 2 - gameCenterButton.frame.height * 2 / 3)
        gameCenterButton.zPosition = 3
        self.addChild(gameCenterButton)
        
        // Create rate button
        rateButton.removeFromParent()
        rateButton = SKSpriteNode(imageNamed: "rateButton")
        rateButton.texture = SKTexture(imageNamed: "rateButton")
        rateButton.texture?.filteringMode = SKTextureFilteringMode.Nearest
        rateButton.setScale(pixelScale)
        rateButton.position = CGPoint(x: playButton.position.x, y: playButton.position.y - playButton.frame.height / 2 - rateButton.frame.height * 2 / 3)
        rateButton.zPosition = 3
        self.addChild(rateButton)
        
        // Create sound button
        soundButton.removeFromParent()
        soundButton = SKSpriteNode(imageNamed: "soundButton")
        soundButton.texture = SKTexture(imageNamed: "soundButton")
        soundButton.texture?.filteringMode = SKTextureFilteringMode.Nearest
        soundButton.setScale(pixelScale)
        soundButton.position = CGPoint(x: playButton.position.x + playButton.frame.width / 2 - soundButton.frame.width / 2, y: playButton.position.y - playButton.frame.height / 2 - soundButton.frame.height * 2 / 3)
        soundButton.zPosition = 3
        self.addChild(soundButton)
    }
    
    // Create background
    func createBackground() {
        print("Background has been reset.")
        
        // Remove background from scene
        background.removeFromParent()
        
        // Get random index from backgroundImage list
        randomBackground = Int(arc4random_uniform(UInt32(backgroundImage.count)))
        // Set background's image to random image picked from backgroundImage
        background = SKSpriteNode(imageNamed: backgroundImage[randomBackground])
        // Set background's texture to random image picked from backgroundImage
        background.texture = SKTexture(imageNamed: backgroundImage[randomBackground])
        // Set background's texture filtering mode to nearest neighbour
        background.texture?.filteringMode = SKTextureFilteringMode.Nearest
        // Scale background
        background.setScale(self.frame.height / background.frame.height)
        // Set background position
        background.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        // Set background z position
        background.zPosition = 0
        
        // Add background to scene
        self.addChild(background)
    }
    
    // Create score label
    func createScoreLabel() {
        // Remove scoreLabel from scene
        scoreLabel.removeFromParent()
        
        // Set scoreLabel's text to score
        scoreLabel = SKLabelNode(text: "\(score)")
        // Set scoreLabel's font
        scoreLabel.fontName = "Chalkduster"
        // Set scoreLabel's font size
        scoreLabel.fontSize = 64
        // Set scoreLabel position
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: 3 * self.frame.height / 4)
        // Set scoreLabel z position
        scoreLabel.zPosition = 6
        
        // Add scoreLabel to scene
        self.addChild(scoreLabel)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        // Allow scene to handle physics contacts
        self.physicsWorld.contactDelegate = self
        
        // Assign values to declared variables
        cubeSide = 1
        
        gravity = -9.8
        pixelScale = 3.0
        
        ballColor = ["ballRed", "ballGreen", "ballBlue", "ballPink"]
        backgroundImage = ["backgroundDay", "backgroundNight"]
        
        // Set gravity magnitude
        self.physicsWorld.gravity = CGVectorMake(0.0, CGFloat(gravity))
        
        // Call functions to set up scene
        resetBall()
        resetCube()
        menuScene()
        createBackground()
        createScoreLabel()
        
        // Don't affect ball by gravity at start
        ball.physicsBody?.affectedByGravity = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        // Check if game isn't started
        if gameSceneStarted == false {
            for touch in touches {
                // Get the location of the touch
                let location = touch.locationInNode(self)
                // Check if the location of the touch is inside the button
                if playButton.containsPoint(location) {
                    print("Game has been started.")
                    
                    // Remove gameOver from scene
                    gameOver.removeFromParent()
                    // Start game
                    gameSceneStarted = true
                    // Reset everything to starting position
                    self.didMoveToView(view!)
                    
                    // Hide all buttons
                    playButton.hidden = true
                    gameCenterButton.hidden = true
                    rateButton.hidden = true
                    soundButton.hidden = true
                    
                    
                    // Remove bronzeMedal from scene
                    bronzeMedal.removeFromParent()
                    // Remove silverMedal from scene
                    silverMedal.removeFromParent()
                    // Remove goldMedal from scene
                    goldMedal.removeFromParent()
                    // Remove platinumMedal from scene
                    platinumMedal.removeFromParent()
                    
                    // Reset score, and update scoreLabel
                    score = 0
                    scoreLabel.text = "\(score)"
                    
                    // Set tapToPlay's image
                    tapToPlay = SKSpriteNode(imageNamed: "tapToPlay")
                    // Set tapToPlay's texture
                    tapToPlay.texture = SKTexture(imageNamed: "tapToPlay")
                    // Set cube's texture filtering mode to nearest neighbour
                    tapToPlay.texture?.filteringMode = SKTextureFilteringMode.Nearest
                    // Scale tapToPlay
                    tapToPlay.setScale(pixelScale)
                    // Set tapToPlay position
                    tapToPlay.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                    // Set tapToPlay z position
                    tapToPlay.zPosition = 4
                    // Add to scene
                    self.addChild(tapToPlay)
                }
            }
            
        } else {
            // Affect ball by gravity
            ball.physicsBody?.affectedByGravity = true
            // Rotate cube 90 degrees clockwise
            cube.runAction(SKAction.rotateByAngle(CGFloat(M_PI/2.0), duration: 0.125))
            // Increment cubeSide
            cubeSide += 1
            // Check if the cubeSide goes over 4
            if cubeSide > 4 {
                // Reset the cubeSide to 1
                cubeSide = 1
            }
            
            tapToPlay.removeFromParent()
        }
    }
    
    // Test physics body contact
    func didBeginContact(contact: SKPhysicsContact) {
        // Declare contact bodies
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        // Test collision between ball and cube
        if firstBody.categoryBitMask == physicsCategory.ball && secondBody.categoryBitMask == physicsCategory.cube ||
            firstBody.categoryBitMask == physicsCategory.cube && secondBody.categoryBitMask == physicsCategory.ball {
            
            // Check if the ball collided with the wrong cube side
            if ballColor[randomBallColor] != "ballRed" && cubeSide == 1 ||
                ballColor[randomBallColor] != "ballGreen" && cubeSide == 2 ||
                ballColor[randomBallColor] != "ballBlue" && cubeSide == 3 ||
                ballColor[randomBallColor] != "ballPink" && cubeSide == 4 {
                
                print("Game is over.")
                
                // Create game over scene
                gameSceneStarted = false
                // Set playButton position
                playButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4)
                // Show playButton
                playButton.hidden = false
                
                // Remove gameOver from scene
                gameOver.removeFromParent()
                // Set gameOver's image
                gameOver = SKSpriteNode(imageNamed: "gameOver")
                // Set gameOver's texture
                gameOver.texture = SKTexture(imageNamed: "gameOver")
                // Set cube's texture filtering mode to nearest neighbour
                gameOver.texture?.filteringMode = SKTextureFilteringMode.Nearest
                // Scale gameOver
                gameOver.setScale(pixelScale)
                // Set gameOver position
                gameOver.position = CGPoint(x: self.frame.width / 2, y: 3 * self.frame.height / 4)
                // Set gameOver z position
                gameOver.zPosition = 4
                // Add gameOver to scene
                self.addChild(gameOver)
                
                ////////////FIX disU P HO
                if score >= 10 && score < 20 {
                    // Remove bronzeMedal from scene
                    bronzeMedal.removeFromParent()
                    // Set bronzeMedal's image
                    bronzeMedal = SKSpriteNode(imageNamed: "bronzeMedal")
                    // Set bronzeMedal's texture
                    bronzeMedal.texture = SKTexture(imageNamed: "bronzeMedal")
                    // Set bronzeMedal's texture filtering mode to nearest neighbour
                    bronzeMedal.texture?.filteringMode = SKTextureFilteringMode.Nearest
                    // Scale bronzeMedal
                    bronzeMedal.setScale(pixelScale)
                    // Set bronzeMedal position
                    bronzeMedal.position = CGPoint(x: gameOver.position.x - gameOver.frame.width / 4, y: gameOver.position.y)
                    // Set bronzeMedal z position
                    bronzeMedal.zPosition = 5
                    // Add bronzeMedal to scene
                    self.addChild(bronzeMedal)
                    
                } else if score >= 20 && score < 30 {
                    // Remove silverMedal from scene
                    silverMedal.removeFromParent()
                    // Set silverMedal's image
                    silverMedal = SKSpriteNode(imageNamed: "silverMedal")
                    // Set silverMedal's texture
                    silverMedal.texture = SKTexture(imageNamed: "silverMedal")
                    // Set silverMedal's texture filtering mode to nearest neighbour
                    silverMedal.texture?.filteringMode = SKTextureFilteringMode.Nearest
                    // Scale silverMedal
                    silverMedal.setScale(pixelScale)
                    // Set silverMedal position
                    silverMedal.position = CGPoint(x: gameOver.position.x - gameOver.frame.width / 4, y: gameOver.position.y)
                    // Set silverMedal z position
                    silverMedal.zPosition = 5
                    // Add silverMedal to scene
                    self.addChild(silverMedal)
                    
                } else if score >= 30 && score < 40 {
                    // Remove goldMedal from scene
                    goldMedal.removeFromParent()
                    // Set goldMedal's image
                    goldMedal = SKSpriteNode(imageNamed: "goldMedal")
                    // Set goldMedal's texture
                    goldMedal.texture = SKTexture(imageNamed: "goldMedal")
                    // Set goldMedal's texture filtering mode to nearest neighbour
                    goldMedal.texture?.filteringMode = SKTextureFilteringMode.Nearest
                    // Scale goldMedal
                    goldMedal.setScale(pixelScale)
                    // Set goldMedal position
                    goldMedal.position = CGPoint(x: gameOver.position.x - gameOver.frame.width / 4, y: gameOver.position.y)
                    // Set goldMedal z position
                    goldMedal.zPosition = 5
                    // Add goldMedal to scene
                    self.addChild(goldMedal)
                    
                } else if score >= 40 {
                    // Remove platinumMedal from scene
                    platinumMedal.removeFromParent()
                    // Set platinumMedal's image
                    platinumMedal = SKSpriteNode(imageNamed: "platinumMedal")
                    // Set platinumMedal's texture
                    platinumMedal.texture = SKTexture(imageNamed: "platinumMedal")
                    // Set platinumMedal's texture filtering mode to nearest neighbour
                    platinumMedal.texture?.filteringMode = SKTextureFilteringMode.Nearest
                    // Scale platinumMedal
                    platinumMedal.setScale(pixelScale)
                    // Set platinumMedal position
                    platinumMedal.position = CGPoint(x: gameOver.position.x - gameOver.frame.width / 4, y: gameOver.position.y)
                    // Set platinumMedal z position
                    platinumMedal.zPosition = 5
                    // Add platinumMedal to scene
                    self.addChild(platinumMedal)
                    
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        // Check if ball exceeds cube, and if game is not over
        if ball.position.y <= cube.position.y && gameSceneStarted == true {
            print("Score has been updated.")
            
            // Reset the ball
            resetBall()
            // Add 1 to score, and update scoreLabel
            score += 1
            scoreLabel.text = "\(score)"
        }
        
        // Check if the ball collided with the corresponding cube side
        if ballColor[randomBallColor] == "ballRed" && cubeSide == 1 ||
            ballColor[randomBallColor] == "ballGreen" && cubeSide == 2 ||
            ballColor[randomBallColor] == "ballBlue" && cubeSide == 3 ||
            ballColor[randomBallColor] == "ballPink" && cubeSide == 4 {
            // Don't allow collision between ball and cube
            ball.physicsBody?.collisionBitMask = 0
            cube.physicsBody?.collisionBitMask = 0
            
        } else {
            // Allow collision between ball and cube
            ball.physicsBody?.collisionBitMask = physicsCategory.cube
            cube.physicsBody?.collisionBitMask = physicsCategory.ball
            
        }
    }
}
