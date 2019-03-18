import Foundation
import UIKit

public class MyView: UIView {
    
    public func config()
    {
        let screenSize = CGRect(x: 0, y: 0, width: environment.screenWidth, height: environment.screenHeight) //define the size of the current view
        let buttonSize = CGSize(width: Int(screenSize.width)/environment.proportionButton, height: Int(screenSize.width)/environment.proportionButton)
        
        var board: [[Cell]] = [] //and array of arrays that stores each pixel on the board
        
        //initializing the buttons
        //initializing the line of buttons
        for line in 1...(environment.nLines){ //from 1 because the first space is a blank
            var columnButtons: [Cell] = []
            //initializing the buttons in a column
            for column in 1...(environment.nColumns) {
                
                let button = Cell(frame: CGRect(x: (buttonSize.width * CGFloat(column)), y: (CGFloat(5 + line) * buttonSize.height), width: buttonSize.width, height: buttonSize.height), position: (line,column))
                
                button.position = (line, column)
                button.backgroundColor = environment.deadCellColor
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.white.cgColor
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside) //allows the user to change the button state
                columnButtons.append(button) //adds the button to the column array
                self.addSubview(button) //adds it to the screen
            }
            board.append(columnButtons)
        }
        
        
        //-----------------------------------------------
        //testando selecionar um botao e mostrar seus vizinhos
        board[8][16].alive = true
        for neighbour in board[8][16].neighbours {
            board[neighbour.line][neighbour.column].backgroundColor = .blue
        }
        //TESTANDO UM CASO EXTREMO DE BOTAO E SEUS VIZINHOS - parte 1 cantos
        board[0][0].alive = true
        for neighbour in board[0][0].neighbours {
            board[neighbour.line][neighbour.column].backgroundColor = .blue
        }
        
        board[environment.nLines-1][environment.nColumns-1].alive = true
        for neighbour in board[environment.nLines-1][environment.nColumns-1].neighbours {
            board[neighbour.line][neighbour.column].backgroundColor = .blue
        }
        
        board[0][environment.nColumns-1].alive = true
        for neighbour in board[0][environment.nColumns-1].neighbours {
            board[neighbour.line][neighbour.column].backgroundColor = .blue
        }
        
        board[environment.nLines-1][0].alive = true
        for neighbour in board[environment.nLines-1][0].neighbours {
            board[neighbour.line][neighbour.column].backgroundColor = .blue
        }
        
        //TESTANDO UM CASO EXTREMO DE BOTAO E SEUS VIZINHOS - parte 2 lados
        board[0][12].alive = true
        for neighbour in board[0][12].neighbours {
            board[neighbour.line][neighbour.column].backgroundColor = .blue
        }
        
        board[15][0].alive = true
        for neighbour in board[15][0].neighbours {
            board[neighbour.line][neighbour.column].backgroundColor = .blue
        }
        //-----------------------------------------------
    }
    
    @objc func buttonAction(sender: Cell!) {
        sender.alive = !sender.alive
    }
    
}
