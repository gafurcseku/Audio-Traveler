//
//  User.swift
//  Audio Traveler
//
//  Created by Gafur on 18/9/21.
//

import Foundation

struct User : Codable {
    var id = UUID()
    let name:String
    let email:String
    let password:String
}
