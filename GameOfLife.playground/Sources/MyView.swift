import Foundation
import UIKit

public class MyView: UIView {
    
    weak var delegate: ButtonDelegate? //var that will delegate the actions of this button to the view controller
    
    public func config() -> ([[Cell]])
    {
        let screenSize = CGRect(x: 0, y: 0, width: environment.screenWidth, height: environment.screenHeight) //define the size of the current view
        let buttonSize = CGSize(width: Int(screenSize.width)/environment.proportionButton, height: Int(screenSize.width)/environment.proportionButton)
        
        var board: [[Cell]] = [] //and array of arrays that stores each pixel on the board
        
        //initializing the board:
        //initializing the current line of cells
        for line in 1...(environment.nLines){ //from 1 because the first space is a blank
            var columnButtons: [Cell] = []
            //initializing the current column of cells
            for column in 1...(environment.nColumns) {
                
                let button = Cell(frame: CGRect(x: (buttonSize.width * CGFloat(column)), y: (CGFloat(5 + line) * buttonSize.height), width: buttonSize.width, height: buttonSize.height), position: (line,column))
                
                button.position = (line, column)
                button.backgroundColor = environment.deadCellColor
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.white.cgColor
                button.addTarget(self, action: #selector(cellAction), for: .touchUpInside) //allows the user to change the button state
                columnButtons.append(button) //adds the button to the column array
                self.addSubview(button) //adds it to the screen
            }
            board.append(columnButtons)
        }
        
        //Setting up the play button
        let playButton = UIButton(frame: CGRect(x: buttonSize.width * 2, y: (CGFloat(40) * buttonSize.height), width: 6 * buttonSize.width, height: buttonSize.height * 3.6))
        //making it round
        playButton.backgroundColor = .clear
        playButton.layer.cornerRadius = 20
        playButton.layer.borderWidth = 1
        playButton.layer.borderColor = UIColor.black.cgColor
        //adding the text
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(environment.textColor, for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        playButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        self.addSubview(playButton)
        
        //Setting up the step button
        let stepButton = UIButton(frame: CGRect(x: buttonSize.width * 9, y: (CGFloat(44.5) * buttonSize.height), width: 6 * buttonSize.width, height: buttonSize.height * 3.6))
        //making it round
        stepButton.backgroundColor = .clear
        stepButton.layer.cornerRadius = 20
        stepButton.layer.borderWidth = 1
        stepButton.layer.borderColor = UIColor.black.cgColor
        //adding the text
        stepButton.setTitle("Step", for: .normal)
        stepButton.setTitleColor(environment.textColor, for: .normal)
        stepButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        stepButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        self.addSubview(stepButton)
        
        
        //---------------------------------------------------------------------------------------------------------------------------------------------
        //DECLARAR O RESTANTE DOS BOTOES AQUI
        //---------------------------------------------------------------------------------------------------------------------------------------------
        
        //---------------------------------------------------------------------------------------------------------------------------------------------
        //INICIALIZAR O CONTROLE DE SE ESTA RODANDO OU NAO
        //---------------------------------------------------------------------------------------------------------------------------------------------
        
        
        //---------------------------------------------------------------------------------------------------------------------------------------------
        //TESTES QUE VAO SER EXCLUIDOS
        //---------------------------------------------------------------------------------------------------------------------------------------------
        board[14][14].alive = true
        board[15][15].alive = true
        board[16][16].alive = true
        
//        for neighbour in board[15][15].neighbours {
//                        board[neighbour.line][neighbour.column].backgroundColor = .blue
//        }
        
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
