//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import UIKit

let view = conwaysLife()
var mode = "Playa"

let controller = Controller(mode: mode, myView: view)

PlaygroundPage.current.liveView = view
