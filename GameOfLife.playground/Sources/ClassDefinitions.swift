//
//  ClassDefinitions.swift
//  GameofLife
//
//  Created by Rafael Ferreira on 15/03/19.
//  Copyright © 2019 Rafael Ferreira. All rights reserved.
//

import Foundation
import UIKit


enum Environment {
    //constants about the size of the playground
    static let screenWidth: Int = 1000
    static let screenHeight: Int = 1000
    static let proportionButton: Int = 80
    static let proportionGrid: Int = 60
    static let nLines: Int = 28
    static let nColumns: Int = 28
    //constants about colors
    static let aliveCellColor: UIColor = UIColor(red: 0.960, green: 0.678, blue: 0.403, alpha: 1)
    static let deadCellColor: UIColor = UIColor(red: 0.890, green: 0.890, blue: 0.890, alpha: 1)
    static let textColor: UIColor = UIColor(red: 0.396, green: 0.803, blue: 0.490, alpha: 1)
    static let secondaryColor: UIColor = UIColor(red: 0.407, green: 0.282, blue: 0.776, alpha: 1)
    static let friendColor: UIColor = UIColor(red: 0.537, green: 0.831, blue: 0.898, alpha: 1)
    static let popUpColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.95)
}

//the labels of the buttons on the playground
enum ButtonTexts: String {
    case Play = "Play"
    case Stop = "Stop"
    case Clear = "Clear"
    case Step = "Step"
    case Plus = "+"
    case Minus = "-"
    //strings of pattern names
    case RPentomino = "R-pentomino"
    case Flower = "Flower"
    case Pulsar = "Pulsar"
    case TenCellRow = "10 Cell Row"
    case Glider = "Glider"
}

//Cell is the class of the interactive objects on the board
public class Cell: UIButton {
    var alive: Bool {
        didSet { //observer that runs this code everytime the value of alive changes
            if alive == true {
                self.backgroundColor = Environment.aliveCellColor
            }
            else {
                self.backgroundColor = Environment.deadCellColor
            }
        }
    }
    var active: Bool
    var position: (Int,Int)
    var neighbours: [(line: Int,column: Int)]
    var boardSize: (nLines: Int, nColumns: Int)
    var computerLocked: Bool //A var that keeps them on the board while on domination mode
    
    public init(frame: CGRect, position: (Int,Int), boardSize: (Int, Int)) {
        self.alive = false
        self.active = false
        self.computerLocked = false
        self.position = position
        self.boardSize = boardSize
        self.neighbours = []
        super.init(frame: frame)
        self.neighbours = self.findNeighbours(position: position)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func findNeighbours(position: (line: Int,row: Int)) -> [(Int,Int)] {
        var validNeighbours: [(Int, Int)] = []
        for line in (position.line - 2)...(position.line) { //checking the lines above and below the current cell
            if line >= 0 && line < boardSize.nLines { //making sure the line is valid
                for row in (position.row - 2)...(position.row) { //checking the rows before and after the current cell
                    if row >= 0 && row < boardSize.nColumns { //checking that the row is a valid one 
                        if line != position.line-1 || row != position.row-1 {
                            validNeighbours.append((line, row))
                        }
                    }
                }
            }
        }
        return validNeighbours
    }
}

protocol ButtonDelegate: class { //delegates the managing of a button to another class
    func buttonDidPress(_ button: UIButton)
}

protocol domDelegate: class {
    func cellDidPress(_ button: Cell)
    func playDidPressDom(_ button: UIButton)
    func didPLayerWinGame(_ button: UIButton) -> Bool
}
