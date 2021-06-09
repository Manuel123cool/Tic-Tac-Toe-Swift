import SpriteKit
import GameplayKit

class ResultScene: SKScene {
    static var result: FieldState?
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.orange
        
        let label = SKLabelNode()
        if ResultScene.result != .playerNone {
            if FieldStates.computerIsCircle {
                if ResultScene.result == .playerCircle {
                    label.text = "You Lost"
                } else {
                    label.text = "You Won"
                }
            } else {
                if ResultScene.result == .playerCross {
                    label.text = "You Lost"
                } else {
                    label.text = "You Won"
                }
            }
        } else {
            label.text = "Draw"
        }
        label.fontSize = 30.0
        label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        label.fontColor = .black
        label.fontName = "Arial-BoldMT"
        self.addChild(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            FieldStates.resetFields()
            
            let gameScene = GameScene(size: self.size)
            let skview = self.view!
            
            skview.presentScene(gameScene)
        }
    }
}
