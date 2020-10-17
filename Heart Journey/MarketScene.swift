//
//  MarketScene.swift
//  Heart Journey
//
//  Created by LEONID KULIKOV on 17.10.2020.
//  Copyright © 2020 LEONID KULIKOV. All rights reserved.
//

import SpriteKit
import GameplayKit

enum MarketState {
    case givingInstruction
    case proposingGoods
    case harmfulGoodChosen
    case healthyGoodChosen
    case terminal
}

class MarketScene: SKScene {
    
    var menuScene: MenuScene?
    private var state: MarketState = .givingInstruction
    private var background: SKSpriteNode?
    private var cat: SKSpriteNode?
    let scripts: [String] = [
        "3_1",
        "3_2"
    ]
    var curScriptNum = 0
    private let productSeries = [
        ["good_burger_fit", "good_avocado_fit"]
    ]
    private let warningScripts = [
        "3_3"
    ]
    private let congratScripts = [
        "3_4"
    ]
    private var curProductSeriesNum = 0
    private var good1: SKSpriteNode?
    private var good2: SKSpriteNode?
    private var narrative: SKSpriteNode?
    private var nextBtn: SKLabelNode?

    override func didMove(to view: SKView) {
        
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        self.background?.size = CGSize(width: self.size.width, height: self.size.height)
        self.background?.position = CGPoint(x: 0, y: 0)
        self.background?.zPosition = 0
        
        let catX: CGFloat = 100
        let catY: CGFloat = 120
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
        case .givingInstruction:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "next" {
                if self.curScriptNum < self.scripts.count {
                    self.giveInstruction(self.curScriptNum, self.scripts)
                    self.curScriptNum += 1
                } else {
                    self.state = .proposingGoods
                    self.removeInstruction()
                    self.step()
                }
            }
        case .proposingGoods:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "healthyGood" {
                self.state = .healthyGoodChosen
                self.step()
            } else if let touchedNodeName = touchedNodeName, touchedNodeName == "harmfulGood" {
                self.state = .harmfulGoodChosen
                self.step()
            } else {
                self.showProductSeries(self.curProductSeriesNum)
                self.curProductSeriesNum += 1
            }
        case .harmfulGoodChosen:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "next" {
                self.state = .healthyGoodChosen
                self.removeInstruction()
            } else {
                self.giveInstruction(0, self.warningScripts)
            }
        case .healthyGoodChosen:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "next" {
                self.state = .terminal
                self.removeInstruction()
                self.step()
            } else {
                self.giveInstruction(0, self.congratScripts)
            }
        case .terminal:
            let transition = SKTransition.moveIn(with: .left, duration: 1)
            self.view?.presentScene(self.menuScene!, transition: transition)
        }
    }
    
    private func showProductSeries(_ seriesNum: Int) {
        let good1X = self.size.width * 1.5
        let good1Y = self.size.height * 0.5
        let good2X = self.size.width * 1.8
        let good2Y = self.size.height * 0.5
        let goodAspectRatio: CGFloat = 1
        let goodWidth: CGFloat = 100
        
        self.good1 = SKSpriteNode(imageNamed: self.productSeries[seriesNum][0])
        self.good1?.name = "harmfulGood"
        self.good1?.position = CGPoint(x: good1X, y: good1Y)
        self.good1?.zPosition = 1
        self.good1?.size = CGSize(width: goodWidth, height: goodWidth * goodAspectRatio)
        self.addChild(good1!)
        self.good1?.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.rotate(byAngle: -0.25, duration: 0.2),
            SKAction.rotate(byAngle: 0.25, duration: 0.2),
            SKAction.rotate(byAngle: 0.25, duration: 0.2),
            SKAction.rotate(byAngle: -0.25, duration: 0.2)
        ])))
        self.good1?.run(SKAction.move(to: CGPoint(x: self.size.width*0.25, y: good1Y), duration: 2))
        
        self.good2 = SKSpriteNode(imageNamed: self.productSeries[seriesNum][1])
        self.good2?.name = "healthyGood"
        self.good2?.position = CGPoint(x: good2X, y: good2Y)
        self.good2?.zPosition = 1
        self.good2?.size = CGSize(width: goodWidth, height: goodWidth * goodAspectRatio)
        self.addChild(good2!)
        self.good2?.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.rotate(byAngle: -0.25, duration: 0.2),
            SKAction.rotate(byAngle: 0.25, duration: 0.2),
            SKAction.rotate(byAngle: 0.25, duration: 0.2),
            SKAction.rotate(byAngle: -0.25, duration: 0.2)
        ])))
        self.good2?.run(SKAction.move(to: CGPoint(x: self.size.width*0.75, y: good2Y), duration: 2))
    }
    
    func giveInstruction(_ scriptNum: Int, _ scripts: [String],
                         _ x_shift: CGFloat = 0, _ y_shift: CGFloat = -120,
                         _ nextBtnText: String = "Next",
                         _ centre: Bool = false) {
        if let _ = self.narrative {
            self.fadeNextBtnOutIn()
            self.fadeNarrativeOutIn(scriptNum, scripts)
        } else {
            self.createNarrative(scriptNum, scripts, x_shift, y_shift)
            self.createNextBtn(nextBtnText, centre)
        }
    }
    
    func removeInstruction(_ callback: (() -> Void)? = nil) {
        self.narrative?.run(SKAction.group([
            SKAction.fadeOut(withDuration: 0.6),
            SKAction.scale(to: 0, duration: 0.6)
        ])) { [weak self] in
            self!.narrative?.removeFromParent()
            self!.narrative = nil
            callback?()
        }
        self.nextBtn?.run(SKAction.group([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.scale(to: 0, duration: 0.5)
        ])) { [weak self] in
            self!.nextBtn?.removeFromParent()
            self!.nextBtn = nil
        }
    }
    
    func createNarrative(_ scriptNum: Int, _ scripts: [String], _ x_shift: CGFloat, _ y_shift: CGFloat) {
        let narrativeAspectRatio: CGFloat = 200 / 340
        let narrativeWidth: CGFloat = self.size.width * 0.8
        
        self.narrative = SKSpriteNode(imageNamed: scripts[scriptNum])
        self.narrative?.name = "narrative"
        self.narrative?.position = CGPoint(x: self.size.width * 0.5 + x_shift, y: self.size.height + y_shift)
        self.narrative?.size = CGSize(width: narrativeWidth, height: narrativeWidth * narrativeAspectRatio)
        self.narrative?.zPosition = 10
        self.narrative?.alpha = 0.0
        self.narrative?.setScale(0)
        self.addChild(self.narrative!)
        self.narrative?.run(
            SKAction.sequence([
//                SKAction.wait(forDuration: 1.5),
                SKAction.group([
                    SKAction.fadeIn(withDuration: 1),
                    SKAction.scale(to: 1, duration: 1)
                ])
            ])
        )
    }
    
    func createNextBtn(_ nextBtnText: String, _ centre: Bool = false) {
        self.nextBtn = SKLabelNode(fontNamed: "Avenir-Black")
        self.nextBtn?.text = nextBtnText
        self.nextBtn?.name = "next"
        self.nextBtn?.fontSize = 48
        self.nextBtn?.fontColor = #colorLiteral(red: 0.1516066194, green: 0.1516112089, blue: 0.1516087353, alpha: 1)
        self.nextBtn?.zPosition = 10
        self.nextBtn?.verticalAlignmentMode = .bottom
        self.nextBtn?.horizontalAlignmentMode = .right
        var x: CGFloat = self.size.width - 50
        if centre {
            x = self.size.width / 2
            self.nextBtn?.horizontalAlignmentMode = .center
        }
        self.nextBtn?.position = CGPoint(x: x, y: 100)
        self.nextBtn?.setScale(0)
        self.addChild(self.nextBtn!)
        self.nextBtn?.run(SKAction.sequence([
//            SKAction.wait(forDuration: 1.5),
            SKAction.scale(to: 1, duration: 1)
        ]))
    }
    
    func fadeNextBtnOutIn() {
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
    }
    
    func fadeNarrativeOutIn(_ nextScriptNum: Int, _ scripts: [String]) {
        self.narrative?.run(
            SKAction.group([
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.scale(to: 0, duration: 0.5)
            ]),
            completion: { [weak self] in
                self!.narrative?.texture = SKTexture(imageNamed: scripts[nextScriptNum])
            }
        )
        
        self.narrative?.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.group([
                SKAction.fadeIn(withDuration: 0.5),
                SKAction.scale(to: 1, duration: 0.5)
            ])
        ]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        if let name = touchedNode.name { self.step(name) }
    }
}
