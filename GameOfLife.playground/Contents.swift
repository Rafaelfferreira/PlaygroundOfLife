//: A UIKit based Playground for presenting user interface

import PlaygroundSupport
import UIKit

let view = conwaysLife(mode: "play")
let controller = Controller(myView: view)

PlaygroundPage.current.liveView = view
