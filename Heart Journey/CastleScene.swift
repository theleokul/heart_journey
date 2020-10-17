//
//  CastleScene.swift
//  Heart Journey
//
//  Created by LEONID KULIKOV on 18.10.2020.
//  Copyright © 2020 LEONID KULIKOV. All rights reserved.
//

import SpriteKit
import GameplayKit

enum CastleState {
    case start
}

class CastleScene: MarketScene {
    
    private var state: CastleState = .start
    private var background: SKSpriteNode?
    private var wizard: SKSpriteNode?
    private var heart: SKSpriteNode?
    private var brokenHeart: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        self.background?.size = CGSize(width: self.size.width, height: self.size.height)
        self.background?.position = CGPoint(x: 0, y: 0)
        self.background?.zPosition = 0
        
        let wizardX: CGFloat = self.size.width * 0.5
        let wizardY: CGFloat = self.size.height * 0.5 - 20
        let wizardAspectRatio: CGFloat = 460 / 300
        let wizardWidth: CGFloat = 200
        
        self.wizard = self.childNode(withName: "//wizard") as? SKSpriteNode
        self.wizard?.size = CGSize(width: wizardWidth, height: wizardWidth * wizardAspectRatio)
        self.wizard?.position = CGPoint(x: wizardX, y: wizardY)
        self.wizard?.zPosition = 1
        
        self.heart = self.childNode(withName: "//heart") as? SKSpriteNode
        self.heart?.size = CGSize(width: 75, height: 75)
        self.heart?.zPosition = 2
        self.heart?.position = CGPoint(x: wizardX - 90, y: wizardY - 40)
        self.heart?.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: 0, y: -20, duration: 0.2),
            SKAction.moveBy(x: 0, y: 20, duration: 0.2),
            SKAction.moveBy(x: 0, y: 20, duration: 0.2),
            SKAction.moveBy(x: 0, y: -20, duration: 0.2)
        ])))
        
        self.brokenHeart = self.childNode(withName: "//brokenHeart") as? SKSpriteNode
        self.brokenHeart?.size = CGSize(width: 75, height: 75)
        self.brokenHeart?.zPosition = 2
        self.brokenHeart?.position = CGPoint(x: wizardX + 90, y: wizardY - 40)
        self.brokenHeart?.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.moveBy(x: 0, y: -20, duration: 0.2),
            SKAction.moveBy(x: 0, y: 20, duration: 0.2),
            SKAction.moveBy(x: 0, y: 20, duration: 0.2),
            SKAction.moveBy(x: 0, y: -20, duration: 0.2)
        ])))
        
        self.step()
    }
    
    private func step(_ touchedNodeName: String? = nil) {
        switch self.state {
        case .start:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "next" {
                let finalScene = SKScene(fileNamed: "FinalScene") as! FinalScene
                finalScene.scaleMode = .resizeFill
                let transition = SKTransition.moveIn(with: .right, duration: 1)
                self.view?.presentScene(finalScene, transition: transition)
            } else {
                self.giveInstruction(0, ["6_1"], 0, -120, "Thank you!", true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        if let name = touchedNode.name { self.step(name) }
    }
}
