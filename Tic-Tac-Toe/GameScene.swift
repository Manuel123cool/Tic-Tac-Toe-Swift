import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameFields: [SKShapeNode]? = []
    var newSceneData: (new: Bool, startCount: Bool, startTime: TimeInterval?) =
        (new: false, startCount: false, startTime: nil)

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.orange
        
        drawFields()
        
        if Int.random(in: 0...1) == 0 {
            computerPlay()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !newSceneData.new else {
            return
        }
        for touch in touches {
            let locationUser = touch.location(in: self)
            for (index, field) in gameFields!.enumerated() {
                if field == atPoint(locationUser) && FieldStates.getState(index) == .playerNone {
                    let state: FieldState
                    if FieldStates.computerIsCircle == true {
                        state = .playerCross
                    } else {
                        state = .playerCircle
                    }
                    drawSymbol(state: state, index: index)
                    if newSceneData.new {
                        return
                    }
                    computerPlay()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if newSceneData.new && !newSceneData.startCount {
            newSceneData.startCount = true
            newSceneData.startTime = currentTime
        }
        
        if let startTime = newSceneData.startTime {
            if (startTime + TimeInterval(3.0)) < currentTime {
                resultScene()
            }
        }
    }
    
    private func drawFields() {
        let rectSideSize = (size.width - size.width / 10) / 3
        let rectSideSizeF = CGFloat(Double(rectSideSize))
        let baseX = CGFloat(Double(rectSideSize / 2))
        let baseY = CGFloat(Double(size.height - rectSideSize / 2) -
            Double((size.height - size.width) / 2))
        
        for index in 0..<9 {
            gameFields!.append(SKShapeNode(rectOf: CGSize(width: rectSideSize, height: rectSideSize)))
            let field = gameFields![index]
            field.fillColor = .brown
            field.strokeColor = SKColor.clear
            let indexF: CGFloat = CGFloat(Double(index))
            if index < 3 {
                let newXBase = baseX + CGFloat(Double((index + 1)) * Double((size.width / 10 / 3)))
                let newYBase = baseY - CGFloat(Double((size.width / 10 / 3)))
                field.position = CGPoint(x: newXBase + indexF * rectSideSizeF, y: newYBase)
            } else if index < 6 {
                let newXBase = baseX + CGFloat(Double((index - 2)) * Double((size.width / 10 / 3)))
                let newYBase = baseY - CGFloat(2.0 * Double((size.width / 10 / 3)))
                field.position = CGPoint(x: newXBase + (indexF - 3) *
                    rectSideSizeF, y: newYBase - rectSideSize)
            } else {
                let newXBase = baseX + CGFloat(Double((index - 5)) * Double((size.width / 10 / 3)))
                let newYBase = baseY - CGFloat(3.0 * Double((size.width / 10 / 3)))
                field.position = CGPoint(x: newXBase + (indexF - 6) *
                    rectSideSizeF, y: newYBase - rectSideSize * 2)
            }

            addChild(gameFields![index])
        }
    }
    
    func drawSymbol(state: FieldState, index: Int, drawRed: Bool = false, first: Bool = false) {
        if drawRed && first {
            removeAllChildren()
            drawFields()
        }
        
        let rectSideSize = Double(size.width - size.width / 10) / 3
        let width: Double = Double(size.width / 50)
        if state == FieldState.playerCross {
            let rectSideMinus = rectSideSize - (sin(45.0 * Double.pi / 180) * width)
            let height = Double(pow(rectSideMinus, 2.0) * 2).squareRoot()
            
            let rect1 = SKShapeNode(rectOf: CGSize(width: width, height: height))
            rect1.fillColor = .black
            if drawRed {
                rect1.fillColor = .red
            }
            rect1.strokeColor = .clear
            rect1.position = gameFields![index].position
            
            let rotationAction1 = SKAction.rotate(byAngle: 45.0 * CGFloat.pi / 180, duration: 0)
            rect1.run(rotationAction1)
            addChild(rect1)
            
            let rect2 = SKShapeNode(rectOf: CGSize(width: width, height: height))
            rect2.fillColor = .black
            if drawRed {
                rect2.fillColor = .red
            }
            rect2.strokeColor = .clear
            rect2.position = gameFields![index].position
            
            let rotationAction2 = SKAction.rotate(byAngle: 45.0 * 3.0 * CGFloat.pi / 180, duration: 0)
            rect2.run(rotationAction2)
            addChild(rect2)
        } else {
            let circle = SKShapeNode(circleOfRadius: CGFloat(rectSideSize / 2 - width / 2))
            circle.fillColor = .brown
            circle.strokeColor = .black
            if drawRed {
                circle.strokeColor = .red
            }
            circle.lineWidth = CGFloat(width)
            circle.position = gameFields![index].position
            
            
            addChild(circle)
        }
        
        guard !drawRed else {
            return
        }
        
        FieldStates.setState(index: index, state: state)
        if checkWin(which: state, gameScene: self) {
            ResultScene.result = state
            if state == .playerCircle {
                newSceneData.new = true
            } else {
                newSceneData.new = true
            }
        } else if checkWin(which: .playerNone, gameScene: self) {
            ResultScene.result = .playerNone
            newSceneData.new = true
        }
    }
    
    private func computerPlay() {
        let availableFields = FieldStates.reAvailableFields()
        if (availableFields.isEmpty) {
            return
        }
        let randomIndex = Int.random(in: 0..<availableFields.count)
        
        let state: FieldState
        if FieldStates.computerIsCircle == true {
            state = .playerCircle
        } else {
            state = .playerCross
        }
        
        drawSymbol(state: state, index: availableFields[randomIndex])
    }
    
    private func resultScene() {
        let resultScene = ResultScene(size: size)
        let skview = self.view!
        
        skview.presentScene(resultScene)
    }
}

func checkWin(which: FieldState, gameScene: GameScene? = nil) -> Bool{
    guard which != .error else {
        print("Error: which is error")
        return false
    }
    let rows = [
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,4,8],
        [2,4,6]
    ]
    
    if which == FieldState.playerNone {
        if FieldStates.reAvailableFields().isEmpty {
            return true
        } else {
            return false
        }
    }
    
    for row in rows {
        var count = 0
        for pos in row {
            if FieldStates.getState(pos) == which {
                count += 1
            }
        }
        if count == 3 && gameScene != nil {
            for (index, pos) in row.enumerated() {
                if index == 0 {
                    gameScene!.drawSymbol(state: which, index: pos, drawRed: true, first: true)
                } else {
                    gameScene!.drawSymbol(state: which, index: pos, drawRed: true, first: false)
                }
            }
            return true
        } else if count == 3 {
            return true
        }
    }
    return false
}
