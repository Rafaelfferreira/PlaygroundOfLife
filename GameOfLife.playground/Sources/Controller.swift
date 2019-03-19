import Foundation
import UIKit

public class Controller: ButtonDelegate {
    var board: [[Cell]]
    
    public init(myView: MyView) {
        self.board = myView.config()
        myView.delegate = self //sets the controller as the delegate of myView
    }
    
    
    public func buttonDidPress(_ button: UIButton) {
        if button.currentTitle == "Play"{
            button.setTitle("Stop", for: .normal)
        }
        else if button.currentTitle == "Stop"{
            button.setTitle("Play", for: .normal)
        }
        else if button.currentTitle == "Step" { //the label on the button changes before this function is calledd
            step(button: button)
        }
    }
    
    public func step(button: UIButton) { //simulates one step on the board
        var aliveNeighbours: Int = 0
        var kill: [(line: Int, column: Int)] = [] //an array that store the coordinates of all the alive cells that should die
        var live: [(line: Int, column: Int)] = [] //an array that store the coordinates of all the dead cells that sould live
            
        //scans the board and find which cells would change
        for (lineIndex, line) in board.enumerated() { //goes through each line
            for (columnIndex, column) in line.enumerated() { //goes through each column
                aliveNeighbours = checkNeighbours(cell: column)
                if (column.alive == false) { //testing the conditions on dead cells
                    if aliveNeighbours == 3 {
                        live.append((line: lineIndex, column: columnIndex))
                    }
                }
                else { //testing the condition on alive cells
                    if aliveNeighbours < 2 { //if an alive cell has less than 2 neighbours it dies
                        kill.append((line: lineIndex, column: columnIndex))
                    }
                    else if aliveNeighbours > 3{
                        kill.append((line: lineIndex, column: columnIndex))
                    }
                    //newBoard[indexLine][indexColumn] = board[indexLine][indexColumn]
                }
            }
        }
            
            //changes alive cells to dead when appropriate
            for cell in kill {
                board[cell.line][cell.column].alive = false
            }
            //changes dead cells to alive when appropriate
            for cell in live {
                board[cell.line][cell.column].alive = true
            }
    }
    
    public func checkNeighbours(cell: Cell) -> Int{ //check how many of the cell's neighbours are still alive
        var aliveNeighbours: Int = 0
        
        for neighbour in cell.neighbours {
            if board[neighbour.line][neighbour.column].alive == true {
                aliveNeighbours += 1
            }
        }
        
        return aliveNeighbours
    }
}

