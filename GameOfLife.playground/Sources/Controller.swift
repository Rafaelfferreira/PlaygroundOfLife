import Foundation
import UIKit

public class Controller: ButtonDelegate, domDelegate {
    var board: [[Cell]]
    var mode: String
    public var isRunning: Bool = false //var that keeps track if the game should be static or evolving
    public var speed: Double = 1 //speed of the game evolution
    var kill: [(line: Int, column: Int)] = [] //an array that store the coordinates of all the alive cells that should die
    var live: [(line: Int, column: Int)] = [] //an array that store the coordinates of all the dead cells that sould live
    var locked: Bool = false //var that keeps track if the board is in a interactive state or not
    
    //initializing the right kind of view based on the input of the user on the playground screen
    public init(mode: String, myView: MyView) {
        self.mode = mode
        if mode.uppercased() == "PLAY" {
            self.board = myView.configPlay()
        }
        else {
            self.board = myView.configDomination()
        }//self.board = myView.configPlay()
        myView.delegate = self //sets the controller as the delegate of myView
        myView.domDelegate = self
    }
    
    //a cell was pressed on DOMINATION mode
    public func cellDidPress(_ button: Cell) {
        if locked == false {
            button.alive = !button.alive
            button.active = true
            if button.alive == true {
                button.backgroundColor = Environment.friendColor
            }
            locked = true
            updateNeighbours()
        }
        else {
            if button.active == true {
                locked = false
                button.alive = !button.alive
                updateNeighbours()
            }
        }
    }
    
    //the player pressed the playButton on DOMINATION mode
    public func playDidPressDom(_ button: UIButton) {
        dominationStep()
        locked = false
    }
    
    //handling all the button presses on the "play" mode
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
        //pattern buttons
        case .RPentomino:
            clear()
            rPentomino()
        case .Flower:
            clear()
            flower()
        case .Pulsar:
            clear()
            pulsar()
        case .TenCellRow:
            clear()
            tenCellRow()
        case .Glider:
            clear()
            glider()
        }
    }
    
    //Starts the auto running on the program
    public func start() {
        if isRunning {
            step()
            DispatchQueue.main.asyncAfter(deadline: .now() + (1/(1.5*speed))) {
                self.start()
            }
        }
    }
    
    //simulates one step on the board
    public func step() {
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
    
    //one step on domination mode
    public func dominationStep() {
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
                }
            }
        }
        
        //changes alive cells to dead when appropriate
        for cell in kill {
            board[cell.line][cell.column].alive = false
        }
        //changes dead cells to alive when appropriate
        for cell in live {
            var redNeighbours = 0
            var blueNeighbours = 0
            board[cell.line][cell.column].alive = true
            
            for neighbour in board[cell.line][cell.column].neighbours { //see how many friendly and unfriendly neighbours it has
                if board[neighbour.line][neighbour.column].backgroundColor == Environment.aliveCellColor {
                    redNeighbours += 1
                }
                else if board[neighbour.line][neighbour.column].backgroundColor == Environment.friendColor {
                    blueNeighbours += 1
                }
            }
            if blueNeighbours > redNeighbours {
                board[cell.line][cell.column].backgroundColor = Environment.friendColor
            }
            
        }
        
        //making sure that theres no leftover on the control array
        kill = []
        live = []
        
        updateNeighbours()
        
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
    
    public func reliveCells(live: [(line: Int, column: Int)]) {
        //changes dead cells to alive when appropriate
        for cell in live {
            board[cell.line][cell.column].alive = true
        }
    }
    
    //functions that active specific patterns they basically append the right coordinates to the live array, call a function that turns all the selected cells on and then empty the array
    public func rPentomino() {
        live.append((13,13))
        live.append((13,14))
        live.append((14,13))
        live.append((14,12))
        live.append((15,13))
        
        reliveCells(live: live)
        live = []
    }
    
    public func flower() {
        live.append((13,13))
        live.append((14,13))
        live.append((14,12))
        live.append((14,14))
        live.append((15,12))
        live.append((15,14))
        live.append((16,13))
        
        reliveCells(live: live)
        live = [] 
    }
    
    public func pulsar() {
        let cells = [(12,11),(13,11),(14,11),(15,11),(16,11),(12,13),(16,13),(12,15),(13,15),(14,15),(15,15),(16,15)]
        live.append(contentsOf: cells)

        reliveCells(live: live)
        live = [] 
    }
    
    public func tenCellRow() {
        let cells = [(13,10),(13,11),(13,12),(13,13),(13,14),(13,15),(13,16),(13,17),(13,18)]
        live.append(contentsOf: cells)
        
        reliveCells(live: live)
        live = [] 
    }
    
    public func glider() {
        let cells = [(14,13),(14,14),(14,15),(13,15),(12,14)]
        live.append(contentsOf: cells)
        
        reliveCells(live: live)
        live = []
    }
    
    public func updateNeighbours() {
        for line in board {
            for column in line {
                var aliveNeighbours = 0
                for neighbour in column.neighbours { //counts how many alive neighbours does it have
                    if board[neighbour.line][neighbour.column].alive == true {
                        aliveNeighbours += 1
                    }
                }
                column.setTitle("\(aliveNeighbours)", for: .normal)
            }
        }

    }
    
}

