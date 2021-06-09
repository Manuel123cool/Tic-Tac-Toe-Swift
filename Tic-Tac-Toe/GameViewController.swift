import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        let firstScene = GameScene(size: self.view.bounds.size)
        let skview = self.view as! SKView
        
        skview.showsFPS = true
        skview.showsNodeCount = true
        
        skview.presentScene(firstScene)
    }
}

