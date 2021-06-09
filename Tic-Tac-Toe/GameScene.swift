import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameFields: [SKShapeNode]? = []
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.orange
        
        drawFields()
        
        if Int.random(in: 0...1) == 0 {
            computerPlay()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
                    
                    computerPlay()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        <#code#>
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
    
    func drawSymbol(state: FieldState, index: Int) {
        FieldStates.setState(index: index, state: state)
        if checkWin(which: state) {
            ResultScene.result = state
            if state == .playerCircle {
                resultScene()
            } else {
                resultScene()
            }
        } else if checkWin(which: .playerNone) {
            ResultScene.result = .playerNone
            resultScene()
        }
        let rectSideSize = Double(size.width - size.width / 10) / 3
        let width: Double = Double(size.width / 50)
        if state == FieldState.playerCross {
            let rectSideMinus = rectSideSize - (sin(45.0 * Double.pi / 180) * width)
            let height = Double(pow(rectSideMinus, 2.0) * 2).squareRoot()
            
            let rect1 = SKShapeNode(rectOf: CGSize(width: width, height: height))
            rect1.fillColor = .black
            rect1.strokeColor = .clear
            rect1.position = gameFields![index].position
            let rotationAction1 = SKAction.rotate(byAngle: 45.0 * CGFloat.pi / 180, duration: 0)
            rect1.run(rotationAction1)
            addChild(rect1)
            
            let rect2 = SKShapeNode(rectOf: CGSize(width: width, height: height))
            rect2.fillColor = .black
            rect2.strokeColor = .clear
            rect2.position = gameFields![index].position
            let rotationAction2 = SKAction.rotate(byAngle: 45.0 * 3.0 * CGFloat.pi / 180, duration: 0)
            rect2.run(rotationAction2)
            addChild(rect2)
        } else {
            let circle = SKShapeNode(circleOfRadius: CGFloat(rectSideSize / 2 - width / 2))
            circle.fillColor = .brown
            circle.strokeColor = .black
            circle.lineWidth = CGFloat(width)
            circle.position = gameFields![index].position
            
            addChild(circle)
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

func checkWin(which: FieldState) -> Bool{
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
        if count == 3 {
            return true
        }
    }
    return false
}
