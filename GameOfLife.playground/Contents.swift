//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import UIKit


let view = MyView(frame: CGRect(x: 20, y: 0, width: 480, height: 600))
let controller = Controller(myView: view)

view.backgroundColor = .white


PlaygroundPage.current.liveView = view
