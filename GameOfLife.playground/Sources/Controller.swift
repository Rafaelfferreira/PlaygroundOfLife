import Foundation
import UIKit

public class Controller: ButtonDelegate {
    var board: [[Cell]]
    
    public init(myView: MyView) {
        self.board = myView.config()
        myView.delegate = self //sets the controller as the delegate of myView
    }
    
    
    func buttonDidPress(_ button: UIButton) {
        if button.currentTitle == "Play" {
            run()
        }
        else {
            print("Stop")
        }
    }
    
    func run() {
        print("Something")
    }
}
