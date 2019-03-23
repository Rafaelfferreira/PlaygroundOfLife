/*:
 ## ***Overview***
 
 This playground was inspired by the lack of engagement many of my classmates in university have toward theoretical computer science subjects. It is an implementation of The Game of Life proposed by mathematician John Conway’s in 1970.
 
 I believe that students feel less invested in theoretical subjects because of the lack of opportunity to apply and experiment with most of the concepts presented during classes. The Game of Life is an excellent tool to fill the gap between the theory and the application of some concepts studied during the course. Let's start by initializing the board.
 */
 import PlaygroundSupport
 import UIKit
 
 let view = conwaysLife()
 var mode = "play"
 
 let controller = Controller(mode: mode, myView: view)
 
 PlaygroundPage.current.liveView = view
/*:
 #### How does it work?
 
 The game is a perfect example of a self organizing system of emergent complexity, that is, a system with few simple rules that can create elaborate patterns and behaviours. You can select which cells are alive by clicking them and than you can press the "Step" button to see how they would evolve one generation by following the 4 rules on the bottom-right corner of the screen. Or press the "Play" button to watch them evolve continuously. (The stepper next to the play button controls the speed of this proccess.)

Use this implementation of the game to play around, try one of the patterns available on the top of the screen and see how they behave, did they do what you expected from them? Try and create your own pattern and see how they behave, create cells in the middle of running patterns and see how it affects them, do not be afraid to test new stuff, this game is almost 50 years old and people are still discovering new things that you could do on it!

 ### Why does it matter?
 
 The game of life is a perfect example of cellular automata, is a turing-complete machine, it can easily illustrate the halting-problem, and many more concepts. This tool could be used as a conversation starter and/or practical demonstrator of those concepts.
 
 If you feel like you already have a good grasp on how Life behaves go to the next page to play a little challenge based on it!
 
 */
//: [Next page](@next)
