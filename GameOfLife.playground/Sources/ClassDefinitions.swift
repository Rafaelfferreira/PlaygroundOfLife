//
//  ClassDefinitions.swift
//  GameofLife
//
//  Created by Rafael Ferreira on 15/03/19.
//  Copyright © 2019 Rafael Ferreira. All rights reserved.
//

import Foundation
import UIKit


enum environment {
    //constants about the size of the playground
    static let screenWidth: Int = 1000
    static let screenHeight: Int = 1000
    static let proportionButton: Int = 50
    static let proportionGrid: Int = 25
    static let nLines: Int = 33
    static let nColumns: Int = 36
    //constants about colors
    static let aliveCellColor: UIColor = UIColor(red: 0.984, green: 0.619, blue: 0.301, alpha: 1)
    static let deadCellColor: UIColor = UIColor(red: 0.890, green: 0.890, blue: 0.890, alpha: 1)
    static let textColor: UIColor = UIColor(red: 0.078, green: 0.686, blue: 0.670, alpha: 1)
}

public class Cell: UIButton {
    var alive: Bool {
        didSet { //observer that runs this code everytime the value of alive changes
            if alive == true {
                self.backgroundColor = environment.aliveCellColor
            }
            else {
                self.backgroundColor = environment.deadCellColor
            }
        }
    }
    var active: Bool
    var position: (Int,Int)
    var neighbours: [(line: Int,column: Int)]!
    
    public init(frame: CGRect, position: (Int,Int)) {
        self.alive = false
        self.active = true
        self.position = position
        super.init(frame: frame)
        self.neighbours = self.findNeighbours(position: position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func findNeighbours(position: (line: Int,row: Int)) -> [(Int,Int)] {
        var validNeighbours: [(Int, Int)] = []
        for line in (position.line - 2)...(position.line) { //checking the lines above and below the current cell
            if line >= 0 && line < environment.nLines { //making sure the line is valid //PROVAVEL QUE TENHA QUE DIMINUIR 1 DAQUI
                for row in (position.row - 2)...(position.row) { //checking the rows before and after the current cell
                    if row >= 0 && row < environment.nColumns { //checking that the row is a valid one //PROVAVEL QUE TENHA QUE DIMINUIT 1 DAQUI TBM
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
