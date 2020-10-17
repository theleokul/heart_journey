//
//  SportScene.swift
//  Heart Journey
//
//  Created by LEONID KULIKOV on 17.10.2020.
//  Copyright © 2020 LEONID KULIKOV. All rights reserved.
//

import SpriteKit
import GameplayKit

enum SportState {
    case start
    case game
    case finish
}

class SportScene: MarketScene {
    
    private var state: SportState = .start
    private var background: SKSpriteNode?
    private var cat: SKSpriteNode?
    private let startScripts = [
        "4_1"
    ]
    private let finishScripts = [
        "4_2"
    ]
    
    override func didMove(to view: SKView) {
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        self.background?.size = CGSize(width: self.size.width, height: self.size.height)
        self.background?.position = CGPoint(x: 0, y: 0)
        self.background?.zPosition = 0
        
        let catX: CGFloat = self.size.width * 0.5
        let catY: CGFloat = self.size.height * 0.5
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
        self.step("next")
    }
    
    private func step(_ touchedNodeName: String? = nil) {
        switch self.state {
        case .start:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "next" {
                if self.curScriptNum < self.startScripts.count {
                    self.giveInstruction(self.curScriptNum, self.startScripts, 0, -150)
                    self.curScriptNum += 1
                } else {
                    self.state = .game
                    self.removeInstruction()
                    self.step()
                }
            }
        case .game:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "cat" {
                self.cat?.removeAllActions()
                self.state = .finish
                self.step()
            } else {
                self.cat?.removeAllActions()
                self.cat?.run(SKAction.scale(to: 0.5, duration: 1))
                self.cat?.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: 0.5),
                        SKAction.repeatForever(
                            SKAction.sequence([
                                SKAction.animate(with: [
                                    SKTexture(imageNamed: "cat_left"),
                                    SKTexture(imageNamed: "cat_right")
                                ], timePerFrame: 0.2)
                            ])
                        )
                    ])
                )
                
                let path = CGMutablePath()
                path.move(to: CGPoint(x: self.size.width/2, y: self.size.height/2))
                path.addQuadCurve(to: CGPoint(x: 70, y: self.size.height - 150),
                                  control: CGPoint(x: -5, y: self.size.height - 300))
                path.addQuadCurve(to: CGPoint(x: self.size.width - 60, y: self.size.height - 150),
                                  control: CGPoint(x: self.size.width/2, y: self.size.height/2))
                path.addCurve(to: CGPoint(x: self.size.width - 90, y: 80),
                              control1: CGPoint(x: self.size.width*1.01, y: self.size.height*0.75),
                              control2: CGPoint(x: self.size.width/2, y: self.size.height*0.25))
                
                path.addLine(to: CGPoint(x: 40, y: 50))
                path.closeSubpath()
                
                self.cat?.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: 0.6),
                        SKAction.repeatForever(
                            SKAction.follow(path as CGPath, asOffset: false, orientToPath: true, duration: 10)
                        )
                    ])
                )
            }
        case .finish:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "next" {
                let transition = SKTransition.moveIn(with: .left, duration: 1)
                self.view?.presentScene(self.menuScene!, transition: transition)
            } else {
                self.giveInstruction(0, self.finishScripts, 0, -150)
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
