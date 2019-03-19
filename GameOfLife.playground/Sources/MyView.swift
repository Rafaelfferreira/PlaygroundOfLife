import Foundation
import UIKit

public class MyView: UIView {
    
    weak var delegate: ButtonDelegate? //var that will delegate the actions of this button to the view controller
    weak var stepperDelegate: StepperDelegate?
    var speedNumber: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) //the only label on the view that needs to be constantly updated
    
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
                button.layer.cornerRadius = 5
                button.layer.borderColor = UIColor.white.cgColor
                button.addTarget(self, action: #selector(cellAction), for: .touchUpInside) //allows the user to change the button state
                columnButtons.append(button) //adds the button to the column array
                self.addSubview(button) //adds it to the screen
            }
            board.append(columnButtons)
        }
        
        //function that creates buttons with the default style of the playground.
        //the X and Y positions are relative to the width and the height of the cells
        func createDefaultButton(buttonLabel: String, posX: Double, posY: Double){ //-> UIButton{
            let returnButton = UIButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 6 * buttonSize.width, height: buttonSize.height * 3.6))
            //making it rounder
            returnButton.backgroundColor = .clear
            returnButton.layer.cornerRadius = 20
            returnButton.layer.borderWidth = 1
            returnButton.layer.borderColor = Environment.textColor.cgColor//UIColor.black.cgColor
            //adding the text
            returnButton.setTitle(buttonLabel, for: .normal)
            returnButton.backgroundColor = Environment.textColor
            returnButton.setTitleColor(UIColor.white, for: .normal)
            returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
            returnButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
            self.addSubview(returnButton)
        }
        
        func addRules(ruleText: String, posX: Double, posY: Double) {
            let rule = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
            rule.text = ruleText
            rule.font = UIFont.systemFont(ofSize: 14)
            self.addSubview(rule)
        }

        //setting up the UI
        //setting up the non interactive buttons
        createDefaultButton(buttonLabel: ButtonTexts.Play.rawValue, posX: 2, posY: 40)
        createDefaultButton(buttonLabel: ButtonTexts.Step.rawValue, posX: 9, posY: 44.5)
        createDefaultButton(buttonLabel: ButtonTexts.Clear.rawValue, posX: 2, posY: 44.5)
        
        //Setting up the speed button with an UIStepper
        let speedButton = UIStepper(frame: CGRect(x: buttonSize.width * CGFloat(9.75), y: (CGFloat(42) * buttonSize.height), width: buttonSize.width, height: buttonSize.height))
        speedButton.minimumValue = 1
        speedButton.maximumValue = 3
        speedButton.autorepeat = false
        speedButton.tintColor = UIColor.white
        speedButton.backgroundColor = Environment.textColor
        speedButton.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
        self.addSubview(speedButton)
        
        //Setting up the UILabels
        let speedLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(10), y: (CGFloat(40.5) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        speedLabel.text = "Speed: "
        speedLabel.textColor = Environment.textColor
        self.addSubview(speedLabel)
        
        //setting up the stater value of the speedNumber label
        speedNumber = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(13), y: (CGFloat(40.5) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        speedNumber.text = "1x"
        speedNumber.textColor = Environment.textColor
        self.addSubview(speedNumber)
        
        //Setting up the rules title
        let rulesLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(17), y: (CGFloat(41) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        rulesLabel.text = "Rules"
        rulesLabel.textColor = Environment.textColor
        rulesLabel.font = UIFont.boldSystemFont(ofSize: rulesLabel.font.pointSize+8.5)
        self.addSubview(rulesLabel)
        
        //setting rules
        addRules(ruleText: "Each cell with less than 2 neighbors dies by underpopulation.", posX: 17, posY: 42.5)
        addRules(ruleText: "Each cell with more than 3 neighbors dies by overpopulation.", posX: 17, posY: 43.5)
        addRules(ruleText: "Each cell with two or three neighbors survives.", posX: 17, posY: 44.5)
        addRules(ruleText: "If a dead cell has three neighbors it comes alive.", posX: 17, posY: 45.5)
        
        //setting the titleLabel
        let titleLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(11.5), y: (CGFloat(1.5) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height*2))
        titleLabel.text = "Conway's Game of Life"
        titleLabel.textColor = Environment.secondaryColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: rulesLabel.font.pointSize+3)
        self.addSubview(titleLabel)
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
    }
    
    @objc func stepperValueChanged(sender: UIStepper) {
        stepperDelegate?.stepperValueChanged(sender)
        if(sender.value == 1) {
            self.speedNumber.text = "1x"
        }
        else if(sender.value == 2){
            self.speedNumber.text = "2x"
        }
        else {
            self.speedNumber.text = "3x"
        }
        
    }
}

protocol ButtonDelegate: class { //delegates the managing of a button to another class
    func buttonDidPress(_ button: UIButton)
}

protocol StepperDelegate: class {
    func stepperValueChanged(_ stepper: UIStepper)
}
