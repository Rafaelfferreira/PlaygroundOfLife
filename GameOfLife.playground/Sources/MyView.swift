import Foundation
import UIKit

public class MyView: UIView {
    
    weak var delegate: ButtonDelegate? //var that will delegate the actions of this button to the view controller
    
    public func config() -> ([[Cell]])
    {
        let screenSize = CGRect(x: 0, y: 0, width: Environment.screenWidth, height: Environment.screenHeight) //define the size of the current view
        let buttonSize = CGSize(width: Int(screenSize.width)/Environment.proportionButton, height: Int(screenSize.width)/Environment.proportionButton)
        
        var board: [[Cell]] = [] //and array of arrays that stores each pixel on the board
        
        //initializing the board:
        //initializing the current line of cells
        for line in 1...(Environment.nLines){ //from 1 because the first space is a blank
            var columnButtons: [Cell] = []
            //initializing the current column of cells
            for column in 1...(Environment.nColumns) {
                
                let button = Cell(frame: CGRect(x: (buttonSize.width * CGFloat(column)), y: (CGFloat(5 + line) * buttonSize.height), width: buttonSize.width, height: buttonSize.height), position: (line,column))
                
                button.position = (line, column)
                button.backgroundColor = Environment.deadCellColor
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.white.cgColor
                button.addTarget(self, action: #selector(cellAction), for: .touchUpInside) //allows the user to change the button state
                columnButtons.append(button) //adds the button to the column array
                self.addSubview(button) //adds it to the screen
            }
            board.append(columnButtons)
        }
        
        //function that creates buttons with the default style of the playground.
        //the X and Y positions are relative to the width and the height of the cells
        func createDefaultButton(buttonLabel: String, posX: Double, posY: Double) -> UIButton{
            let returnButton = UIButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 6 * buttonSize.width, height: buttonSize.height * 3.6))
            //making it round
            returnButton.backgroundColor = .clear
            returnButton.layer.cornerRadius = 20
            returnButton.layer.borderWidth = 1
            returnButton.layer.borderColor = UIColor.black.cgColor
            //adding the text
            returnButton.setTitle(buttonLabel, for: .normal)
            returnButton.setTitleColor(Environment.textColor, for: .normal)
            returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
            returnButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
            self.addSubview(returnButton)
            return returnButton
        }
        
        //Setting up the play button
        let playButton = createDefaultButton(buttonLabel: ButtonTexts.Play.rawValue, posX: 2, posY: 40)
        let stepButton = createDefaultButton(buttonLabel: ButtonTexts.Step.rawValue, posX: 9, posY: 44.5)
        let clearButton = createDefaultButton(buttonLabel: ButtonTexts.Clear.rawValue, posX: 2, posY: 44.5)
        
        //---------------------------------------------------------------------------------------------------------------------------------------------
        //TESTES QUE VAO SER EXCLUIDOS
        //---------------------------------------------------------------------------------------------------------------------------------------------
        board[14][15].alive = true
        board[14][16].alive = true
        board[15][14].alive = true
        board[15][15].alive = true
        board[16][15].alive = true
        return board
    }
    
    //what happens when you click a cell
    @objc func cellAction(sender: Cell!) {
        sender.alive = !sender.alive
    }
    
    @objc func buttonDelegate(sender: UIButton) {
        delegate?.buttonDidPress(sender)
//        if (sender.currentTitle == "Play") {
//            sender.setTitle("Stop", for: .normal)
//        }
//        else if (sender.currentTitle == "Stop"){
//            sender.setTitle("Play", for: .normal)
//        }
    }
}

protocol ButtonDelegate: class { //delegates the managing of a button to another class
    func buttonDidPress(_ button: UIButton)
}
