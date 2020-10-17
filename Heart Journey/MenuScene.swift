//
//  MenuScene.swift
//  Heart Journey
//
//  Created by LEONID KULIKOV on 17.10.2020.
//  Copyright © 2020 LEONID KULIKOV. All rights reserved.
//

import SpriteKit
import GameplayKit

enum MenuState {
    case first
    case second
    case third
    case castle
}

class MenuScene: SKScene {
    
    private var background: SKSpriteNode?
    private var cat: SKSpriteNode?
    private var firstLevelPoint: CGPoint?
    private var secondLevelPoint: CGPoint?
    private var thirdLevelPoint: CGPoint?
    private var castleLevelPoint: CGPoint?
    private var state: MenuState = .first
    
    override func didMove(to view: SKView) {
        
        if self.state == .first {
            self.deployFirstState()
        } else if self.state == .second {
            self.deploySecondState()
        } else if self.state == .third {
            self.deployThirdState()
        } else if self.state == .castle {
            self.deployCastleState()
        }
        
        
    }
    
    private func deployFirstState() {
        self.firstLevelPoint = CGPoint(x: 140, y: 220)
        self.secondLevelPoint = CGPoint(x: 250, y: 400)
        self.thirdLevelPoint = CGPoint(x: 80, y: 600)
        self.castleLevelPoint = CGPoint(x: self.size.width/2, y: 700)
        
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        self.background?.size = CGSize(width: self.size.width, height: self.size.height)
        self.background?.position = CGPoint(x: 0, y: 0)
        self.background?.zPosition = 0
        
        let catX: CGFloat = self.size.width - 100
        let catY: CGFloat = 140
        let catAspectRatio: CGFloat = 289 / 332
        let catWidth: CGFloat = 140
        
        self.cat = self.childNode(withName: "//cat") as? SKSpriteNode
        self.cat?.size = CGSize(width: catWidth, height: catWidth * catAspectRatio)
        self.cat?.position = CGPoint(x: catX, y: catY)
        self.cat?.zPosition = 1
        self.cat?.run(
            SKAction.group([
                SKAction.scale(to: 0.9, duration: 2),
                SKAction.move(to: self.firstLevelPoint!, duration: 2),
                SKAction.animate(with: [
                    SKTexture(imageNamed: "cat_left"),
                    SKTexture(imageNamed: "cat_right"),
                    SKTexture(imageNamed: "cat_left"),
                    SKTexture(imageNamed: "cat_right")
                ], timePerFrame: 0.5)
            ])) { [weak self] in
                
            let marketScene = SKScene(fileNamed: "MarketScene") as! MarketScene
            marketScene.scaleMode = .resizeFill
            marketScene.menuScene = self
            let transition = SKTransition.moveIn(with: .right, duration: 1)
            self!.view?.presentScene(marketScene, transition: transition)
        }
        
        self.state = .second
    }
    
    private func deploySecondState() {
        self.cat?.run(
            SKAction.group([
                SKAction.scale(to: 0.7, duration: 2),
                SKAction.move(to: self.secondLevelPoint!, duration: 2),
                SKAction.animate(with: [
                    SKTexture(imageNamed: "cat_left"),
                    SKTexture(imageNamed: "cat_right"),
                    SKTexture(imageNamed: "cat_left"),
                    SKTexture(imageNamed: "cat_right")
                ], timePerFrame: 0.5)
            ])) { [weak self] in
                
            let sportScene = SKScene(fileNamed: "SportScene") as! SportScene
            sportScene.scaleMode = .resizeFill
            sportScene.menuScene = self
            let transition = SKTransition.moveIn(with: .right, duration: 1)
            self!.view?.presentScene(sportScene, transition: transition)
        }
        
        self.state = .third
    }
    
    private func deployThirdState() {
        self.cat?.run(
            SKAction.group([
                SKAction.scale(to: 0.4, duration: 2),
                SKAction.move(to: self.thirdLevelPoint!, duration: 2),
                SKAction.animate(with: [
                    SKTexture(imageNamed: "cat_left"),
                    SKTexture(imageNamed: "cat_right"),
                    SKTexture(imageNamed: "cat_left"),
                    SKTexture(imageNamed: "cat_right")
                ], timePerFrame: 0.5)
            ])) { [weak self] in
                
            let bookScene = SKScene(fileNamed: "BookScene") as! BookScene
            bookScene.scaleMode = .resizeFill
            bookScene.menuScene = self
            let transition = SKTransition.moveIn(with: .right, duration: 1)
            self!.view?.presentScene(bookScene, transition: transition)
        }
        
        self.state = .castle
    }
    
    private func deployCastleState() {
        self.cat?.run(
            SKAction.group([
                SKAction.scale(to: 0.2, duration: 2),
                SKAction.move(to: self.castleLevelPoint!, duration: 2),
                SKAction.animate(with: [
                    SKTexture(imageNamed: "cat_left"),
                    SKTexture(imageNamed: "cat_right"),
                    SKTexture(imageNamed: "cat_left"),
                    SKTexture(imageNamed: "cat_right")
                ], timePerFrame: 0.5)
            ])) { [weak self] in
                
            let castleScene = SKScene(fileNamed: "CastleScene") as! CastleScene
            castleScene.scaleMode = .resizeFill
            castleScene.menuScene = self
            let transition = SKTransition.moveIn(with: .right, duration: 1)
            self!.view?.presentScene(castleScene, transition: transition)
        }
    }
}
