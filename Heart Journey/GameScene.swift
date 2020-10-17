//
//  GameScene.swift
//  Heart Journey
//
//  Created by LEONID KULIKOV on 16.10.2020.
//  Copyright © 2020 LEONID KULIKOV. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let scripts: [String] = [
        "1_1",
        "1_2",
        "1_3"
    ]
    private var curScriptNum = 0
    private var background : SKSpriteNode?
    private var cat: SKSpriteNode?
    private var narrative: SKSpriteNode?
    private var nextBtn: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        self.background = self.childNode(withName: "//background_1") as? SKSpriteNode
        self.background?.size = CGSize(width: self.size.width, height: self.size.height)
        self.background?.position = CGPoint(x: 0, y: 0)
        self.background?.zPosition = 0
        
        let catSideX = self.size.width * 1.5
        let catSideY = self.size.height * 0.5
        let catAspectRatio: CGFloat = 289 / 332
        let catWidth: CGFloat = 500
        
        self.cat = self.childNode(withName: "//cat") as? SKSpriteNode
        self.cat?.position = CGPoint(x: catSideX, y: catSideY - 80)
        self.cat?.zPosition = 1
        self.cat?.size = CGSize(width: catWidth, height: catWidth * catAspectRatio)
        self.cat?.run(
            SKAction.sequence([
                SKAction.moveTo(x: self.size.width * 0.5, duration: 2.0),
                SKAction.wait(forDuration: 0.5),
                SKAction.repeatForever(
                    SKAction.sequence([
                        SKAction.animate(with: [
                            SKTexture(imageNamed: "cat_left"),
                            SKTexture(imageNamed: "cat_right")
                        ], timePerFrame: 1.0)
                    ])
                )
            ])
        )
        
        let narrativeAspectRatio: CGFloat = 200 / 340
        let narrativeWidth: CGFloat = self.size.width * 0.8
        self.narrative = SKSpriteNode(imageNamed: self.scripts[self.curScriptNum])
        self.narrative?.name = "narrative"
        self.narrative?.position = CGPoint(x: self.size.width * 0.5, y: self.size.height - 340)
        self.narrative?.size = CGSize(width: narrativeWidth, height: narrativeWidth * narrativeAspectRatio)
        self.narrative?.zPosition = 2
        self.narrative?.alpha = 0.0
        self.narrative?.setScale(0)
        self.addChild(self.narrative!)
        self.narrative?.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.5),
                SKAction.group([
                    SKAction.fadeIn(withDuration: 1),
                    SKAction.scale(to: 1, duration: 1)
                ])
            ])
        )
        
        self.nextBtn = SKLabelNode(fontNamed: "Avenir-Black")
        self.nextBtn?.text = "Next"
        self.nextBtn?.name = "next"
        self.nextBtn?.fontSize = 48
        self.nextBtn?.fontColor = #colorLiteral(red: 0.1516066194, green: 0.1516112089, blue: 0.1516087353, alpha: 1)
        self.nextBtn?.zPosition = 3
        self.nextBtn?.verticalAlignmentMode = .bottom
        self.nextBtn?.horizontalAlignmentMode = .center
        self.nextBtn?.position = CGPoint(x: self.size.width * 0.5, y: 150)
        self.nextBtn?.setScale(0)
        self.addChild(self.nextBtn!)
        self.nextBtn?.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.scale(to: 1, duration: 1)
        ]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        if let name = touchedNode.name {
            if name == "next" {
                
                self.nextBtn?.run(SKAction.sequence([
                    SKAction.group([
                        SKAction.fadeOut(withDuration: 0.5),
                        SKAction.scale(to: 0, duration: 0.5)
                    ]),
                    SKAction.wait(forDuration: 0.6),
                    SKAction.group([
                        SKAction.fadeIn(withDuration: 0.5),
                        SKAction.scale(to: 1, duration: 0.5)
                    ])
                ]))
                
                self.curScriptNum += 1
                if self.curScriptNum < self.scripts.count {
                    self.narrative?.run(
                        SKAction.group([
                            SKAction.fadeOut(withDuration: 0.5),
                            SKAction.scale(to: 0, duration: 0.5)
                        ]),
                        completion: { [weak self] in
                            self!.narrative?.texture = SKTexture(imageNamed: self!.scripts[self!.curScriptNum])
                        }
                    )
                    
                    self.narrative?.run(SKAction.sequence([
                        SKAction.wait(forDuration: 0.6),
                        SKAction.group([
                            SKAction.fadeIn(withDuration: 0.5),
                            SKAction.scale(to: 1, duration: 0.5)
                        ])
                    ]))
                } else {
                    let menuScene = SKScene(fileNamed: "MenuScene")!
                    menuScene.scaleMode = .resizeFill
                    let transition = SKTransition.moveIn(with: .right, duration: 1)
                    self.view?.presentScene(menuScene, transition: transition)
                }
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
