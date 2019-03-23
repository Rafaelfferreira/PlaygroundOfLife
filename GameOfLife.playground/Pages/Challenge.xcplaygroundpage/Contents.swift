//: [Previous page](@previous)
/*:
 ### Challenge
 Welcome to challenge mode! First off let's start the board and then we'll go over the rules.
 */
import PlaygroundSupport
import UIKit

//note that is the same exact initialization procces, just changing the var mode
let view = conwaysLife()
var mode = "challenge"

let controller = Controller(mode: mode, myView: view)

PlaygroundPage.current.liveView = view
/*:
 ### Rules:
 
 This challenge consists on you trying to beat the emerging complexity and make so that at the end of 10 turns you the board have more blue cells than red ones.
 To do this you may revive one blue cell per turn. After you do this, you press the "next turn" button and see how that cell you revived affected the board.
 
 The most important thing to notice is that, new cells appear when a dead cell has 3 alive neighbours and **they appear of the same color of the majority of their neighbours** (so if a cell has 2 blue neighbours and 1 red, it will appear blue and so on).
 In order to make it easier this board display how many active neighbours each cell currently has.
 
 ### Tips:
 * Keep an eye on cells that already have 2 neighbours and try to make the cell you revive make them reach 3.
 * Make sure that your current live cells wont die on the next turn, try and make it so they have more than 1 neighbour and less than 4.
 * You can eliminate red cells by reviving a cell in the neighbourhood of cells that already have 3 neighbours.
 */
