//
//  GameScene.swift
//  Game-Starter-Empty
//
//  Created by mitchell hudson on 9/13/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    func setupScoreBoard() {
        guard let scene = scene else {return}
        
        scoreLabel.fontSize = 30
        updateScore(score: score)
        
        let xPos = scoreLabel.frame.size.width/2 + 10
        let yPos = (scene.frame.size.height) - (scoreLabel.frame.size.height) - 40
        
        let pointPosition = CGPoint(x: xPos, y: yPos)
        scoreLabel.position = pointPosition
        
        addChild(scoreLabel)
    }
    
    func updateScore(score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
    
    
    func makeSquares() {
        
        let size = CGSize(width: 60, height: 60)
        let squareFigure = SKSpriteNode(color: .green, size: size)
        squareFigure.position.x = CGFloat(random(n: Int(self.size.width)))
        squareFigure.name = "bubble"
        let moveAction = SKAction.moveTo(y: self.size.height, duration: 10)
        let updateScore = SKAction.run {
            self.score -= 1
            self.updateScore(score: self.score)
            self.handleGameOver(status: self.isGameOver())
        }
        let removeSquare = SKAction.removeFromParent()
        
        let sequenceAction = SKAction.sequence([moveAction, removeSquare, updateScore])
        squareFigure.run(sequenceAction)
        
        addChild(squareFigure) // adding a node square to the phone screen
    }
  
  
    override func didMove(to view: SKView) {
        // Called when the scene has been displayed
        let wait = SKAction.wait(forDuration: 1)
        let make = SKAction.run {
            self.makeSquares()
        }
        
        let sequenceMakeMultiple = SKAction.sequence([make, wait])
        let repeatSequence = SKAction.repeatForever(sequenceMakeMultiple)
        setupScoreBoard()
        self.run(repeatSequence)
        
    }
    
  
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    func random(n: Int) -> Int { // custom random function
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            
            if node.name == "bubble" {
                score += 1
                updateScore(score: score)
                node.removeFromParent()
            }
        }
    }
    
    func handleGameOver(status: Bool) {
        let message = "You lost!"
        
        let view = SKShapeNode(rectOf: CGSize(width: 300, height: 250))
        
        view.fillColor = SKColor.white
        view.zPosition = 50
        view.position = self.view!.center
        addChild(view)
        
        let label = SKLabelNode()
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        view.addChild(label)
        label.position = CGPoint(x: 0, y: 60)
        
        // restart button - stretch challenge
        
        
        self.removeAllActions()
        
    }
    
    func isGameOver() -> Bool {
        return (score < 0)
    }
}

