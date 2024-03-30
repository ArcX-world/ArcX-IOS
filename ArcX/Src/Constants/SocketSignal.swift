//
// Created by LLL on 2024/2/23.
//

import Foundation

struct SocketSignal {
    static let START_GAME = 0
    static let MOVE_UP = 1
    static let MOVE_DOWN = 2
    static let MOVE_LEFT = 3
    static let MOVE_RIGHT = 4
    static let STOP_MOVE = 5
    static let CATCH = 6
    static let PUSH = 8
    static let QUIT_GAME = 9
    static let DROP = 13
    static let SHOOT = 16
    static let CHANGE_GUN = 17
    static let AUTO_SHOOT = 20
    static let STOP_SHOOT = 21
    static let SOLO_SETTLEMENT = 23
    static let AUTO_PUSH = 24
    static let STOP_PUSH = 25
}
