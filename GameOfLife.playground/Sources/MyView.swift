import Foundation
import UIKit

public class MyView: UIView {
    
    weak var delegate: ButtonDelegate? //var that will delegate the actions of this button to the view controller
    weak var stepperDelegate: StepperDelegate?
    var speed: Int = 1//Integer that will store the current speed
    var speedNumber: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) //the only label on the view that needs to be constantly updated
    
    public func config() -> ([[Cell]])
    {
        let screenSize = CGRect(x: 0, y: 0, width: Environment.screenWidth, height: Environment.screenHeight) //define the size of the current view
        let buttonSize = CGSize(width: Int(screenSize.width)/Environment.proportionGrid, height: Int(screenSize.width)/Environment.proportionGrid)
        
        var board: [[Cell]] = [] //and array of arrays that stores each pixel on the board
        
        //initializing the board:
        //initializing the current line of cells
        for line in 1...(Environment.nLines){ //from 1 because the first space is a blank
            var columnButtons: [Cell] = []
            //initializing the current column of cells
            for column in 1...(Environment.nColumns) {
                
                let button = Cell(frame: CGRect(x: (buttonSize.width * CGFloat(column)), y: (CGFloat(3 + line) * buttonSize.height), width: buttonSize.width, height: buttonSize.height), position: (line,column))
                
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
            let returnButton = UIButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 4.5 * buttonSize.width, height: buttonSize.height * 1.5))
            //making it rounder
            returnButton.backgroundColor = .clear
            returnButton.layer.cornerRadius = 5
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
        
        func createRoundButton(buttonLabel: String, posX: Double, posY: Double) {
            let returnButton = UIButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 1.5 * buttonSize.width, height: buttonSize.height * 1.5))
            //making it rounder
            returnButton.backgroundColor = .clear
            returnButton.layer.cornerRadius = 3
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
            rule.font = UIFont.systemFont(ofSize: 10)
            self.addSubview(rule)
        }

        //setting up the UI
        //setting up the non interactive buttons
        createDefaultButton(buttonLabel: ButtonTexts.Play.rawValue, posX: 1, posY: 33.5)
        createDefaultButton(buttonLabel: ButtonTexts.Step.rawValue, posX: 6, posY: 35.5)
        createDefaultButton(buttonLabel: ButtonTexts.Clear.rawValue, posX: 1, posY: 35.5)
        createRoundButton(buttonLabel: ButtonTexts.Minus.rawValue, posX: 6, posY: 33.5)
        createRoundButton(buttonLabel: ButtonTexts.Plus.rawValue, posX: 9, posY: 33.5)
        
        //Setting up the speed button with an UIStepper
//        let speedButton = UIStepper(frame: CGRect(x: buttonSize.width * CGFloat(8.8), y: (CGFloat(31.2) * buttonSize.height), width: 2, height: 2))
//        speedButton.minimumValue = 1
//        speedButton.maximumValue = 3
//        speedButton.autorepeat = false
//        speedButton.tintColor = UIColor.white
//        speedButton.transform.scaledBy(x: 0.5, y: 0.5)
//        speedButton.layer.cornerRadius = 5
//        speedButton.backgroundColor = Environment.textColor
//        speedButton.addTarget(self, action: #selector(stepperValueChanged(sender:)), for: .valueChanged)
//        self.addSubview(speedButton)
        
        //Setting up the UILabels
        let speedLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(6.6), y: (CGFloat(32.2) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        speedLabel.text = "Speed"
        speedLabel.textColor = Environment.textColor
        speedLabel.font = UIFont.boldSystemFont(ofSize: speedLabel.font.pointSize+1)
        self.addSubview(speedLabel)
        
        //setting up the stater value of the speedNumber label
        speedNumber = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(7.7), y: (CGFloat(33.6) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        speedNumber.text = "1x"
        speedNumber.textColor = Environment.textColor
        self.addSubview(speedNumber)
        
        //Setting up the rules title
        let rulesLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(11.3), y: (CGFloat(32.2) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        rulesLabel.text = "Rules"
        rulesLabel.textColor = Environment.textColor
        rulesLabel.font = UIFont.boldSystemFont(ofSize: rulesLabel.font.pointSize+1.5)
        self.addSubview(rulesLabel)
        
        //setting rules
        addRules(ruleText: "Each cell with less than 2 neighbors dies by underpopulation.", posX: 11.3, posY: 33.5)
        addRules(ruleText: "Each cell with more than 3 neighbors dies by overpopulation.", posX: 11.3, posY: 34.3)
        addRules(ruleText: "Each cell with two or three neighbors survives.", posX: 11.3, posY: 35.1)
        addRules(ruleText: "If a dead cell has three neighbors it comes alive.", posX: 11.3, posY: 35.9)
        
        //setting the titleLabel
        let titleLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(8), y: (CGFloat(0.5) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height*2))
        titleLabel.text = "Conway's Game of Life"
        titleLabel.textColor = Environment.secondaryColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: rulesLabel.font.pointSize+1)
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
            self.speedNumber.text = "`x"
        }
    }
    
//    @objc func stepperValueChanged(sender: UIStepper) {
//        stepperDelegate?.stepperValueChanged(sender)
////        if(sender.value == 1) {
////            self.speedNumber.text = "1x"
////        }
////        else if(sender.value == 2){
////            self.speedNumber.text = "2x"
////        }
////        else {
////            self.speedNumber.text = "3x"
////        }
//
//    }
}
