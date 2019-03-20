import Foundation
import UIKit

public class Controller: ButtonDelegate {
    var board: [[Cell]]
    public var isRunning: Bool = false //var that keeps track if the game should be static or evolving
    public var speed: Double = 1 //speed of the game evolution
    var kill: [(line: Int, column: Int)] = [] //an array that store the coordinates of all the alive cells that should die
    var live: [(line: Int, column: Int)] = [] //an array that store the coordinates of all the dead cells that sould live
    
    public init(myView: MyView) {
        self.board = myView.config()
        myView.delegate = self //sets the controller as the delegate of myView
    }
    
    public func buttonDidPress(_ button: UIButton) {
        guard let kind = ButtonTexts(rawValue: button.currentTitle ?? "") else { return }
        
        switch(kind){
        case .Play:
            button.setTitle(ButtonTexts.Stop.rawValue, for: .normal)
            isRunning = true
            start()
        case .Stop:
            button.setTitle(ButtonTexts.Play.rawValue, for: .normal)
            isRunning = false
        case .Step:
            step()
        case .Clear:
            clear()
        case .Minus:
            if speed > 1 {
                speed -= 1
            }
        case .Plus:
            if speed < 3 {
                speed += 3
            }
        }
    }
    
    public func start() {
        if isRunning {
            step()
            DispatchQueue.main.asyncAfter(deadline: .now() + (1/(1.5*speed))) {
                self.start()
            }
        }
    }
    
    public func step() { //simulates one step on the board
        var aliveNeighbours: Int = 0

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
        
        //making sure that theres no leftover on the control array
        kill = []
        live = []
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
    
    public func clear() {
        var kill: [(line: Int, column: Int)] = [] //an array that store the coordinates of all the alive cells that should die
        
        for (lineIndex, line) in self.board.enumerated() { //goes through each line
            for (columnIndex, column) in line.enumerated() {
                if column.alive{
                    kill.append((line: lineIndex, column: columnIndex))
                }
            }
        }
        
        //changes alive cells to dead when appropriate
        for cell in kill {
            board[cell.line][cell.column].alive = false
        }
        
        kill = []
    }
    
}

