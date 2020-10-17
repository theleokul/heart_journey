//
//  FinalScene.swift
//  Heart Journey
//
//  Created by LEONID KULIKOV on 18.10.2020.
//  Copyright © 2020 LEONID KULIKOV. All rights reserved.
//

import SpriteKit
import GameplayKit

class FinalScene: MarketScene {
    
    private var background: SKSpriteNode?
    private var cat: SKSpriteNode?
    private var heart: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        self.background?.size = CGSize(width: self.size.width, height: self.size.height)
        self.background?.position = CGPoint(x: 0, y: 0)
        self.background?.zPosition = 0
        
        let catX: CGFloat = self.size.width/2
        let catY: CGFloat = self.size.height/2 - 150
        let catAspectRatio: CGFloat = 289 / 332
        let catWidth: CGFloat = 200
        
        self.cat = self.childNode(withName: "//cat") as? SKSpriteNode
        self.cat?.size = CGSize(width: catWidth, height: catWidth * catAspectRatio)
        self.cat?.position = CGPoint(x: catX, y: catY)
        self.cat?.zPosition = 1
        self.cat?.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.animate(with: [
                        SKTexture(imageNamed: "cat_left"),
                        SKTexture(imageNamed: "cat_right")
                    ], timePerFrame: 1.0)
                ])
            )
        )
        
        self.heart = self.childNode(withName: "//heart") as? SKSpriteNode
        self.heart?.size = CGSize(width: 100, height: 100)
        self.heart?.position = CGPoint(x: catX, y: catY + 200)
        self.heart?.zPosition = 2
        self.heart?.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveBy(x: 0, y: -20, duration: 0.2),
                    SKAction.moveBy(x: 0, y: 20, duration: 0.2),
                    SKAction.moveBy(x: 0, y: 20, duration: 0.2),
                    SKAction.moveBy(x: 0, y: -20, duration: 0.2)
                ])
            )
        )
        
        self.giveInstruction(0, ["7_1"], 0, -120, "The end!", true)
    }
}
