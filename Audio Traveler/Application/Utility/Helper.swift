//
//  Helper.swift
//  Audio Traveler
//
//  Created by Gafur on 18/9/21.
//

import Foundation
struct Helper{
    
    static func DebugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
            let output = items.map { "\($0)" }.joined(separator: separator)
            Swift.print(output, terminator: terminator)
        #else
            Swift.print("RELEASE MODE")
        #endif
    }

    
    static var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: Constansts.isUserLogin)
    }
    
    static func setLoggedIn(to flag:Bool) {
        UserDefaults.standard.set(flag, forKey: Constansts.isUserLogin)
        UserDefaults.standard.synchronize()
    }
    
    static var userID: String {
        return UserDefaults.standard.string(forKey: Constansts.isUserID) ?? ""
    }
    
    static func setUserID(_ uID: String) {
        UserDefaults.standard.set(uID, forKey: Constansts.isUserID)
        UserDefaults.standard.synchronize()
    }
}
