import Foundation
import UIKit

public class MyView: UIView {
    
    weak var delegate: ButtonDelegate? //var that will delegate the actions of this button to the view controller
    weak var domDelegate: domDelegate?
    var speed: Int = 1//Integer that will store the current speed
    var speedNumber: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) //the only label on the view that needs to be constantly updated
    let buttonSize = CGSize(width: Int(Environment.screenWidth)/Environment.proportionGrid, height: Int(Environment.screenHeight)/Environment.proportionGrid)
    var turns: Int = 10 //how many turns are left on the domination game
    var playerWin: Bool = false //if the player won the domination game
    
    //function that creates buttons with the default style of this playground.
    //the X and Y positions are relative to the width and the height of the cells
    func createDefaultButton(buttonLabel: String, posX: Double, posY: Double){ //-> UIButton{
        let returnButton = UIButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 4.5 * buttonSize.width, height: buttonSize.height * 1.25))
        //making it rounder
        returnButton.backgroundColor = .clear
        returnButton.layer.cornerRadius = 5
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = Environment.textColor.cgColor//UIColor.black.cgColor
        //adding the text
        returnButton.setTitle(buttonLabel, for: .normal)
        returnButton.backgroundColor = UIColor.white
        returnButton.setTitleColor(Environment.textColor, for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        returnButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        if buttonLabel == "Play" {
            returnButton.backgroundColor = Environment.textColor
            returnButton.setTitleColor(UIColor.white, for: .normal)
        }
        self.addSubview(returnButton)
    }
    
    //create the top buttons that store the different patterns of the game
    func createPatternButton(buttonLabel: String, posX: Double, posY: Double){ //-> UIButton{
        let returnButton = UIButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 5.4 * buttonSize.width, height: buttonSize.height * 1))
        //making it rounder
        returnButton.backgroundColor = .clear
        returnButton.layer.cornerRadius = 5
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = Environment.textColor.cgColor//UIColor.black.cgColor
        //adding the text
        returnButton.setTitle(buttonLabel, for: .normal)
        returnButton.backgroundColor = UIColor.white
        returnButton.setTitleColor(Environment.textColor, for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        returnButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        self.addSubview(returnButton)
    }
    
    //function that create the + and - rounded buttons
    func createRoundButton(buttonLabel: String, posX: Double, posY: Double) {
        let returnButton = UIButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 1.25 * buttonSize.width, height: buttonSize.height * 1.25))
        //making it rounder
        returnButton.backgroundColor = .clear
        returnButton.layer.cornerRadius = 10
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = Environment.textColor.cgColor//UIColor.black.cgColor
        //adding the text
        returnButton.setTitle(buttonLabel, for: .normal)
        returnButton.backgroundColor = UIColor.white
        returnButton.setTitleColor(Environment.textColor, for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        returnButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        self.addSubview(returnButton)
    }
    
    //function that add the rules on plain text
    func addRules(ruleText: String, posX: Double, posY: Double) {
        let rule = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        rule.text = ruleText
        rule.font = UIFont.systemFont(ofSize: 9.25)
        self.addSubview(rule)
    }
    
    //configuring the normal play-style of the board (to just experiment)
    public func configPlay() -> ([[Cell]])
    {
        var board: [[Cell]] = [] //and array of arrays that stores each pixel on the board
        
        
        self.backgroundColor = .white
        //initializing the board:
        //initializing the current line of cells
        for line in 1...(Environment.nLines){ //from 1 because the first space is a blank
            var columnButtons: [Cell] = []
            //initializing the current column of cells
            for column in 1...(Environment.nColumns) {

                let button = Cell(frame: CGRect(x: (buttonSize.width * CGFloat(column)), y: (CGFloat(3 + line) * buttonSize.height), width: buttonSize.width, height: buttonSize.height), position: (line,column), boardSize: (Environment.nLines, Environment.nColumns))
                
                button.position = (line, column)
                button.backgroundColor = Environment.deadCellColor
                button.layer.borderWidth = 1.0
                button.layer.cornerRadius = 5
                button.layer.borderColor = UIColor.white.cgColor
                button.addTarget(self, action: #selector(cellAction), for: .touchUpInside) //allows the user to change the button state
                columnButtons.append(button) //adds the button to the column array
                self.addSubview(button) //adds it to the screen
            }
            board.append(columnButtons)
        }

        //setting up the UI
        //setting up the non interactive buttons
        createDefaultButton(buttonLabel: ButtonTexts.Play.rawValue, posX: 1, posY: 33.75)
        createDefaultButton(buttonLabel: ButtonTexts.Step.rawValue, posX: 6, posY: 35.5)
        createDefaultButton(buttonLabel: ButtonTexts.Clear.rawValue, posX: 1, posY: 35.5)
        createRoundButton(buttonLabel: ButtonTexts.Minus.rawValue, posX: 6, posY: 33.75)
        createRoundButton(buttonLabel: ButtonTexts.Plus.rawValue, posX: 9.25, posY: 33.75)
        //settind up the template buttons:
        createPatternButton(buttonLabel: ButtonTexts.RPentomino.rawValue, posX: 1.2, posY: 2.8)
        createPatternButton(buttonLabel: ButtonTexts.Flower.rawValue, posX: 6.8, posY: 2.8)
        createPatternButton(buttonLabel: ButtonTexts.Pulsar.rawValue, posX: 12.4, posY: 2.8)
        createPatternButton(buttonLabel: ButtonTexts.TenCellRow.rawValue, posX: 18, posY: 2.8)
        createPatternButton(buttonLabel: ButtonTexts.Glider.rawValue, posX: 23.6, posY: 2.8)
        
        //setting up the stater value of the speedNumber label
        speedNumber = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(7.65), y: (CGFloat(33.90) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        speedNumber.text = "1x"
        speedNumber.font = UIFont.boldSystemFont(ofSize: 18)
        speedNumber.textColor = Environment.textColor
        self.addSubview(speedNumber)
        
        //Setting up the rules title
        let rulesLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(11.2), y: (CGFloat(32.5) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        rulesLabel.text = "Rules"
        rulesLabel.textColor = Environment.textColor
        rulesLabel.font = UIFont.boldSystemFont(ofSize: rulesLabel.font.pointSize)
        self.addSubview(rulesLabel)
        
        //setting rules
        addRules(ruleText: "Each cell with less than 2 neighbors dies by underpopulation.", posX: 11.3, posY: 33.5)
        addRules(ruleText: "Each cell with more than 3 neighbors dies by overpopulation.", posX: 11.3, posY: 34.3)
        addRules(ruleText: "Each cell with two or three neighbors survives.", posX: 11.3, posY: 35.1)
        addRules(ruleText: "If a dead cell has three neighbors it comes alive.", posX: 11.3, posY: 35.9)
        
        //setting the titleLabel
        let titleLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(9), y: (CGFloat(0.5) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height*2))
        titleLabel.text = "conway's game of life"
        titleLabel.textColor = Environment.secondaryColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: rulesLabel.font.pointSize)
        self.addSubview(titleLabel)
        return board
    }
    
    //configuring the domination style challenge
    public func configDomination() -> ([[Cell]]) {
        var board: [[Cell]] = [] //and array of arrays that stores each pixel on the board
        let buttonSize = CGSize(width: 35, height: 35)
        
        self.backgroundColor = .white
        //initializing the board:
        //initializing the current line of cells
        for line in 1...(8){ //from 1 because the first space is a blank
            var columnButtons: [Cell] = []
            //initializing the current column of cells
            for column in 1...(8) {
                let button = Cell(frame: CGRect(x: ((buttonSize.width) * CGFloat(column) + 65), y: (CGFloat(3 + line) * buttonSize.height), width: buttonSize.width, height: buttonSize.height), position: (line,column), boardSize: (8,8))
                
                button.position = (line, column)
                button.backgroundColor = Environment.deadCellColor
                button.layer.borderWidth = 1.0
                button.layer.cornerRadius = 5
                button.layer.borderColor = UIColor.white.cgColor
                button.addTarget(self, action: #selector(dominationCellAction), for: .touchUpInside) //allows the user to change the button state
                columnButtons.append(button) //adds the button to the column array
                self.addSubview(button) //adds it to the screen
            }
            board.append(columnButtons)
        }
        
        //setting the titleLabel
        let titleLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(4.4), y: (CGFloat(0.5) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height*2))
        titleLabel.text = "conway's game of life"
        titleLabel.textColor = Environment.secondaryColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        self.addSubview(titleLabel)
        
        let turnsLabe = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(4.85), y: (CGFloat(2.75) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        turnsLabe.text = "Turns Left:"
        turnsLabe.font = UIFont.boldSystemFont(ofSize: 23)
        turnsLabe.textColor = Environment.textColor
        self.addSubview(turnsLabe)
        
        //setting up the stater value of the speedNumber label, on the Domination mode this var store how many turns are left until the end of the game!
        speedNumber = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(8.1), y: (CGFloat(2.75) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        speedNumber.text = String(turns)
        speedNumber.font = UIFont.boldSystemFont(ofSize: 23)
        speedNumber.textColor = Environment.textColor
        self.addSubview(speedNumber)
        
        
        //setting up the label on the title of the rules
        let rulesLabel = UILabel(frame: CGRect(x: 100, y: 495, width: buttonSize.width*19, height: buttonSize.height))
        rulesLabel.text = "Rules"
        rulesLabel.textColor = Environment.textColor
        rulesLabel.font = UIFont.boldSystemFont(ofSize: rulesLabel.font.pointSize)
        self.addSubview(rulesLabel)
        
        //Addindg the next turn
        let returnButton = UIButton(frame: CGRect(x: 190, y: 440, width: 100, height: buttonSize.height * 1.25))
        //making it rounder
        returnButton.backgroundColor = .clear
        returnButton.layer.cornerRadius = 10
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = Environment.textColor.cgColor//UIColor.black.cgColor
        //adding the text
        returnButton.setTitle("Next turn", for: .normal)
        returnButton.backgroundColor = Environment.textColor
        returnButton.setTitleColor(UIColor.white, for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        returnButton.addTarget(self, action: #selector(playButtonDomination), for: .touchUpInside)
        self.addSubview(returnButton)
        
        //setting rules
        addRules(ruleText: "Each cell with less than 2 neighbors dies by underpopulation.", posX: 6.3, posY: 32.5)
        addRules(ruleText: "Each cell with more than 3 neighbors dies by overpopulation.", posX: 6.3, posY: 33.3)
        addRules(ruleText: "Each cell with two or three neighbors survives.", posX: 6.3, posY: 34.1)
        addRules(ruleText: "If a dead cell has three neighbors it comes alive.", posX: 6.3, posY: 34.9)
        
        //setting um the RPentomino starting pattern
        setRPentominoDom(board: board)
        
        return board
    }
    
    public func Error() -> [[Cell]] {
        self.backgroundColor = .white
        
        let error = UILabel(frame: CGRect(x: 180, y: 100, width: 300, height: 200))
        error.text = "Error"
        error.font = UIFont.boldSystemFont(ofSize: 60)
        error.textColor = Environment.secondaryColor
        self.addSubview(error)
        
        var errorMessage = UILabel(frame: CGRect(x: 80, y: 150, width: 340, height: 200))
        errorMessage.text = "It seems like your trying to access"
        errorMessage.font = UIFont.boldSystemFont(ofSize: 20)
        errorMessage.textColor = Environment.textColor
        self.addSubview(errorMessage)
        
        errorMessage = UILabel(frame: CGRect(x: 115, y: 170, width: 340, height: 200))
        errorMessage.text = "a mode that doesn't exist 🤔"
        errorMessage.font = UIFont.boldSystemFont(ofSize: 20)
        errorMessage.textColor = Environment.textColor
        self.addSubview(errorMessage)
        
        errorMessage = UILabel(frame: CGRect(x: 70, y: 200, width: 340, height: 200))
        errorMessage.text = "The 2 methods currently implemented are \"Play\" and \"Challenge\""
        errorMessage.font = UIFont.boldSystemFont(ofSize: 10)
        errorMessage.textColor = UIColor.gray
        self.addSubview(errorMessage)
        
        return []
    }
    public func setRPentominoDom(board: [[Cell]]) {
        var pentominoCoordinates: [(line: Int,column: Int)] = [(3,3),(3,4),(4,2),(4,3),(5,3)]
        
        for cell in pentominoCoordinates {
            board[cell.line][cell.column].alive = true
            board[cell.line][cell.column].computerLocked = true
        }
        
        //making two of the first cells friendly
        let friendly = pentominoCoordinates.remove(at: Int.random(in: 0..<pentominoCoordinates.count))
        board[friendly.line][friendly.column].backgroundColor = Environment.friendColor
        
        updateNeighbours(board: board)
    }
    
    public func endGame() {
        
        let endPopUp = UIView(frame: CGRect(x: 115, y: 200, width: 250, height: 125))
        endPopUp.backgroundColor = Environment.popUpColor
        endPopUp.layer.cornerRadius = 5
        self.addSubview(endPopUp)
        
        var mainMessage: UILabel
        var subMessage: UILabel
        var subDefaultMessage: UILabel
        
        //the label "SubDefaultMessage" prints the same 3 lines on the popup with the player winning or losing
        subDefaultMessage = UILabel(frame: CGRect(x: 146, y: 262, width: 200, height: 20))
        subDefaultMessage.text = "To retry just run this playground's code"
        subDefaultMessage.font = UIFont.systemFont(ofSize: 10)
        subDefaultMessage.textColor = UIColor.gray
        self.addSubview(subDefaultMessage)
        
        subDefaultMessage = UILabel(frame: CGRect(x: 140, y: 274, width: 210, height: 20))
        subDefaultMessage.text = "again. You can also change it back to free"
        subDefaultMessage.font = UIFont.systemFont(ofSize: 10)
        subDefaultMessage.textColor = UIColor.gray
        self.addSubview(subDefaultMessage)
        
        subDefaultMessage = UILabel(frame: CGRect(x: 146, y: 286, width: 210, height: 20))
        subDefaultMessage.text = "play mode by \"Challenge\" to \"Play\" on"
        subDefaultMessage.font = UIFont.systemFont(ofSize: 10)
        subDefaultMessage.textColor = UIColor.gray
        self.addSubview(subDefaultMessage)
        
        subDefaultMessage = UILabel(frame: CGRect(x: 185, y: 298, width: 210, height: 20))
        subDefaultMessage.text = "\"var mode\" in the console"
        subDefaultMessage.font = UIFont.systemFont(ofSize: 10)
        subDefaultMessage.textColor = UIColor.gray
        self.addSubview(subDefaultMessage)
        
        if playerWin == false {
            mainMessage = UILabel(frame: CGRect(x: 188, y: 210, width: 200, height: 22))
            mainMessage.text = "You Lost :("
            mainMessage.font = UIFont.boldSystemFont(ofSize: 20)
            mainMessage.textColor = UIColor.gray
            self.addSubview(mainMessage)
            
            subMessage = UILabel(frame: CGRect(x: 140, y: 240, width: 250, height: 20))
            subMessage.text = "But that's okay, Life can get pretty hard!"
            subMessage.font = UIFont.systemFont(ofSize: 10)
            subMessage.textColor = UIColor(cgColor: UIColor.gray.cgColor)
            self.addSubview(subMessage)
        }
        else {
            mainMessage = UILabel(frame: CGRect(x: 165, y: 210, width: 200, height: 30))
            mainMessage.text = "Congratulations!"
            mainMessage.font = UIFont.boldSystemFont(ofSize: 20)
            self.addSubview(mainMessage)
            
            subMessage = UILabel(frame: CGRect(x: 145, y: 240, width: 250, height: 20))
            subMessage.text = "You were able to beat life's complexity!"
            subMessage.font = UIFont.systemFont(ofSize: 10)
            subMessage.textColor = UIColor(cgColor: UIColor.gray.cgColor)
            self.addSubview(subMessage)
        }
    }
    
    //what happens when you click a cell
    @objc func cellAction(sender: Cell) {
        sender.alive = !sender.alive
    }
    
    //what happens when you click a cell
    @objc func dominationCellAction(sender: Cell) {
        domDelegate?.cellDidPress(sender)
    }
    
    @objc func playButtonDomination(sender: UIButton) {
        if turns > 1 {
            turns -= 1
            domDelegate?.playDidPressDom(sender)
        }
        else if turns == 1 {
            turns -= 1
            playerWin = domDelegate?.didPLayerWinGame(sender) ?? false
            endGame()
        }
        self.speedNumber.text = String(turns)
    }
    
    @objc func buttonDelegate(sender: UIButton) {
        delegate?.buttonDidPress(sender)
        if sender.currentTitle == ButtonTexts.Minus.rawValue && speed > 1 {
            speed -= 1
        }
        else if sender.currentTitle == ButtonTexts.Plus.rawValue && speed < 3 {
            speed += 1
        }
        
        switch speed {
        case 1:
            self.speedNumber.text = "1x"
        case 2:
            self.speedNumber.text = "2x"
        case 3:
            self.speedNumber.text = "3x"
        default:
            self.speedNumber.text = "x"
        }
    }
    
    //updating the number of neighbours displayed on each cell
    public func updateNeighbours(board: [[Cell]]) {
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

//function that starts the playground view, this happens in a function to hide the view creation from the user
public func conwaysLife() -> MyView{
    let view = MyView(frame: CGRect(x: 20, y: 0, width: 480, height: 600))
    return view
}
