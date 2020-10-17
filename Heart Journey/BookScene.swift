//
//  BookScene.swift
//  Heart Journey
//
//  Created by LEONID KULIKOV on 17.10.2020.
//  Copyright © 2020 LEONID KULIKOV. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BookState {
    case fadeInCatClosedBook
    case fadeInQuestionAnswers
    case fadeInTrueAnswer
    case fadeInAstraZeneca
    case terminal
}

class BookScene: MarketScene {
    
    private var state: BookState = .fadeInCatClosedBook
    private var background: SKSpriteNode?
    private var cat: SKSpriteNode?
    private var closedBook: SKSpriteNode?
    private var openedBook: SKSpriteNode?
    private var narrative: SKSpriteNode?
    private var nextBtn: SKLabelNode?
    
    private var questionLabel: SKSpriteNode?
    private var answer1Label: SKSpriteNode?
    private var answer2Label: SKSpriteNode?
    private var answer3Label: SKSpriteNode?
    private var answer4Label: SKSpriteNode?
    
    private var astraZenecaLogo: SKSpriteNode?
    
    private let startScripts = ["5_1"]
    private let questionScripts = ["5_2"]
    private let answerScripts = ["5_3", "5_4", "5_5", "5_6"]
    private let trueAnswerScripts = ["5_7"]
    private let astrazenecaScripts = ["5_8"]
    
    override func didMove(to view: SKView) {
        self.background = self.childNode(withName: "//background") as? SKSpriteNode
        self.background?.size = CGSize(width: self.size.width, height: self.size.height)
        self.background?.position = CGPoint(x: 0, y: 0)
        self.background?.zPosition = 0
        
        self.step()
    }
    
    private func step(_ touchedNodeName: String? = nil) {
        switch self.state {
        case .fadeInCatClosedBook:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "next" {
                self.fadeOutCatClosedBook()
                self.removeInstruction()
                self.state = .fadeInQuestionAnswers
                self.step()
            } else {
                self.fadeInCatClosedBook()
                self.giveInstruction(0, self.startScripts, 0, -140)
            }
        case .fadeInQuestionAnswers:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "answer" {
                self.fadeOutAnswers()
                self.state = .fadeInTrueAnswer
                self.step()
            } else {
                self.fadeInQuestionAnswers()
            }
        case .fadeInTrueAnswer:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "next" {
                self.fadeOutQuestionOpenedBook()
                self.removeInstruction() { [weak self] in
                    self!.giveInstruction(0, self!.astrazenecaScripts, 0, -140)
                }
                self.state = .fadeInAstraZeneca
                self.step()
            } else {
                self.giveInstruction(0, self.trueAnswerScripts, 0, -140)
            }
        case .fadeInAstraZeneca:
            self.fadeInCatAstraZeneca()
//            self.giveInstruction(0, self.astrazenecaScripts, 0, -500)
            self.state = .terminal
        case .terminal:
            if let touchedNodeName = touchedNodeName, touchedNodeName == "next" {
                let transition = SKTransition.moveIn(with: .left, duration: 1)
                self.view?.presentScene(self.menuScene!, transition: transition)
            }
        }
    }
    
    private func fadeInCatAstraZeneca() {
        self.cat?.run(
            SKAction.move(to: CGPoint(x: self.size.width * 0.5, y: self.cat!.position.y), duration: 2)
        )
        
        let astraZenecaAspectRatio: CGFloat = 90 / 243
        let astraZenecaWidth: CGFloat = self.size.width*0.7
        let astraZenecaX: CGFloat = self.size.width/2
        let astraZenecaY: CGFloat = 450
        
        self.astraZenecaLogo = SKSpriteNode(imageNamed: "astrazeneca")
        self.astraZenecaLogo?.name = "answer"
        self.astraZenecaLogo?.zPosition = 6
        self.astraZenecaLogo?.size = CGSize(width: astraZenecaWidth, height: astraZenecaWidth * astraZenecaAspectRatio)
        self.astraZenecaLogo?.position = CGPoint(x: astraZenecaX, y: astraZenecaY)
        self.astraZenecaLogo?.alpha = 0
        self.astraZenecaLogo?.setScale(0)
        self.addChild(self.astraZenecaLogo!)
        self.astraZenecaLogo?.run(SKAction.sequence([
            SKAction.group([
                SKAction.fadeIn(withDuration: 1),
                SKAction.scale(to: 1, duration: 1)
            ])
        ]))
    }
    
    private func fadeOutQuestionOpenedBook() {
        self.questionLabel?.run(SKAction.group([
            SKAction.fadeOut(withDuration: 1),
            SKAction.scale(to: 0, duration: 1)
        ]))
        
        self.openedBook?.run(SKAction.group([
            SKAction.fadeOut(withDuration: 1),
//            SKAction.scale(to: 0, duration: 1)
        ]))
    }
    
    private func fadeOutAnswers() {
        self.answer1Label?.run(SKAction.group([
            SKAction.fadeOut(withDuration: 1),
            SKAction.scale(to: 0, duration: 1)
        ])) { [weak self] in
            self?.answer1Label?.removeFromParent()
            self?.answer1Label = nil
        }
        
        self.answer2Label?.run(SKAction.group([
            SKAction.fadeOut(withDuration: 1),
            SKAction.scale(to: 0, duration: 1)
        ])) { [weak self] in
            self?.answer2Label?.removeFromParent()
            self?.answer2Label = nil
        }
        
        self.answer3Label?.run(SKAction.group([
            SKAction.fadeOut(withDuration: 1),
            SKAction.scale(to: 0, duration: 1)
        ])) { [weak self] in
            self?.answer3Label?.removeFromParent()
            self?.answer3Label = nil
        }
        
        self.answer4Label?.run(SKAction.group([
            SKAction.fadeOut(withDuration: 1),
            SKAction.scale(to: 0, duration: 1)
        ])) { [weak self] in
            self?.answer4Label?.removeFromParent()
            self?.answer4Label = nil
        }
    }
    
    private func fadeInQuestionAnswers() {
        let openedBookAspectRatio: CGFloat = 350 / 400
        let openedBookWidth: CGFloat = self.size.width * 0.9
        
        self.openedBook = self.childNode(withName: "//openedBook") as? SKSpriteNode
        self.openedBook?.size = CGSize(width: openedBookWidth,
                                       height: openedBookWidth * openedBookAspectRatio)
        self.openedBook?.zPosition = 5
        self.openedBook?.position = CGPoint(x: self.size.width * 0.5,
                                            y: self.size.height - 400)
        self.openedBook?.run(SKAction.fadeIn(withDuration: 2))
        
        let questionLabelAspectRatio: CGFloat = 200 / 340
        let questionLabelWidth: CGFloat = openedBookWidth - 60
        
        self.questionLabel = SKSpriteNode(imageNamed: questionScripts[0])
        self.questionLabel?.zPosition = 6
        self.questionLabel?.size = CGSize(width: questionLabelWidth,
                                          height: questionLabelWidth * questionLabelAspectRatio)
        self.questionLabel?.position = CGPoint(x: self.size.width * 0.5, y: self.size.height - 380)
        self.questionLabel?.alpha = 0
        self.questionLabel?.setScale(0)
        self.addChild(self.questionLabel!)
        self.questionLabel?.run(SKAction.sequence([
            SKAction.group([
                SKAction.fadeIn(withDuration: 1),
                SKAction.scale(to: 1, duration: 1)
            ])
        ]))
        
        let answerAspectRatio: CGFloat = 40 / 80
        let answerWidth: CGFloat = 80
        let answer12Y: CGFloat = 220
        let answer34Y: CGFloat = 120
        
        self.answer1Label = SKSpriteNode(imageNamed: answerScripts[0])
        self.answer1Label?.name = "answer"
        self.answer1Label?.zPosition = 6
        self.answer1Label?.size = CGSize(width: answerWidth, height: answerWidth * answerAspectRatio)
        self.answer1Label?.position = CGPoint(x: self.size.width * 0.25, y: answer12Y)
        self.answer1Label?.alpha = 0
        self.answer1Label?.setScale(0)
        self.addChild(self.answer1Label!)
        self.answer1Label?.run(SKAction.sequence([
            SKAction.group([
                SKAction.fadeIn(withDuration: 1),
                SKAction.scale(to: 1, duration: 1)
            ])
        ]))
        
        self.answer2Label = SKSpriteNode(imageNamed: answerScripts[1])
        self.answer2Label?.name = "answer"
        self.answer2Label?.zPosition = 6
        self.answer2Label?.size = CGSize(width: answerWidth, height: answerWidth * answerAspectRatio)
        self.answer2Label?.position = CGPoint(x: self.size.width * 0.75, y: answer12Y)
        self.answer2Label?.alpha = 0
        self.answer2Label?.setScale(0)
        self.addChild(self.answer2Label!)
        self.answer2Label?.run(SKAction.sequence([
            SKAction.group([
                SKAction.fadeIn(withDuration: 1),
                SKAction.scale(to: 1, duration: 1)
            ])
        ]))
        
        self.answer3Label = SKSpriteNode(imageNamed: answerScripts[2])
        self.answer3Label?.name = "answer"
        self.answer3Label?.zPosition = 6
        self.answer3Label?.size = CGSize(width: answerWidth, height: answerWidth * answerAspectRatio)
        self.answer3Label?.position = CGPoint(x: self.size.width * 0.25, y: answer34Y)
        self.answer3Label?.alpha = 0
        self.answer3Label?.setScale(0)
        self.addChild(self.answer3Label!)
        self.answer3Label?.run(SKAction.sequence([
            SKAction.group([
                SKAction.fadeIn(withDuration: 1),
                SKAction.scale(to: 1, duration: 1)
            ])
        ]))
        
        self.answer4Label = SKSpriteNode(imageNamed: answerScripts[3])
        self.answer4Label?.name = "answer"
        self.answer4Label?.zPosition = 6
        self.answer4Label?.size = CGSize(width: answerWidth, height: answerWidth * answerAspectRatio)
        self.answer4Label?.position = CGPoint(x: self.size.width * 0.75, y: answer34Y)
        self.answer4Label?.alpha = 0
        self.answer4Label?.setScale(0)
        self.addChild(self.answer4Label!)
        self.answer4Label?.run(SKAction.sequence([
            SKAction.group([
                SKAction.fadeIn(withDuration: 1),
                SKAction.scale(to: 1, duration: 1)
            ])
        ]))
    }
    
    private func fadeInCatClosedBook() {
        let catX: CGFloat = -self.size.width * 0.5
        let catY: CGFloat = self.size.height * 0.3
        let catAspectRatio: CGFloat = 289 / 332
        let catWidth: CGFloat = 200
        
        self.cat = self.childNode(withName: "//cat") as? SKSpriteNode
        self.cat?.size = CGSize(width: catWidth, height: catWidth * catAspectRatio)
        self.cat?.position = CGPoint(x: catX, y: catY)
        self.cat?.zPosition = 2
        self.cat?.run(
            SKAction.sequence([
                SKAction.move(to: CGPoint(x: self.size.width * 0.25, y: catY), duration: 2),
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
        
        let closedBookX: CGFloat = self.size.width * 1.5
        let closedBookY: CGFloat = self.size.height * 0.4
        let closedBookWidth: CGFloat = catWidth
        
        self.closedBook = self.childNode(withName: "//closedBook") as? SKSpriteNode
        self.closedBook?.size = CGSize(width: closedBookWidth, height: closedBookWidth * 1)
        self.closedBook?.position = CGPoint(x: closedBookX, y: closedBookY)
        self.closedBook?.zPosition = 1
        self.closedBook?.run(SKAction.move(to: CGPoint(x: self.size.width * 0.75, y: closedBookY), duration: 2))
    }
    
    private func fadeOutCatClosedBook() {
        self.cat?.run(
            SKAction.move(to: CGPoint(x: -self.size.width * 0.5, y: self.cat!.position.y), duration: 2)
        )
//        { [weak self] in
//            self?.cat?.removeFromParent()
//            self?.cat = nil
//        }
        
        self.closedBook?.run(
            SKAction.move(to: CGPoint(x: self.size.width * 1.5, y: self.closedBook!.position.y), duration: 2)
        ) { [weak self] in
            self?.closedBook?.removeFromParent()
            self?.closedBook = nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene = touch!.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        if let name = touchedNode.name { self.step(name) }
    }
}
