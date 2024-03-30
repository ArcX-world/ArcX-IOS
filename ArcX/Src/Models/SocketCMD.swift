//
// Created by LLL on 2024/3/14.
//

import Foundation

struct SocketCMD {
    struct C2S {
        static let HEARTBEAT = 1001
        static let USER_ENERGY = 1101
        static let TOKEN_BALANCE = 1003
        static let MCH_REFRESH = 1201
        static let MCH_INFO = 1203
        static let MCH_JOIN = 1205
        static let MCH_LEAVE = 1207
        static let DB_INFO = 1225
    }

    struct S2C {
        static let HEARTBEAT = 1002
        static let USER_ENERGY = 1102
        static let TOKEN_BALANCE = 1004
        static let MCH_REFRESH = 1202
        static let MCH_INFO = 1204
        static let MCH_JOIN = 1206
        static let MCH_KICK_OUT = 1208
        static let DB_INFO = 1226
        static let DB_BONUS = 1228
        static let MCH_VOICE_EVENT = 1216
    }
}
