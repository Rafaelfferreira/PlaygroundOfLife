//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import UIKit


let view = MyView(frame: CGRect(x: 20, y: 0, width: 760, height: 1000))

//width: 2732, height: 2048

view.backgroundColor = .white
view.config()
PlaygroundPage.current.liveView = view
