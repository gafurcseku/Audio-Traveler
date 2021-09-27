//
//  AudioLocation.swift
//  Audio Traveler
//
//  Created by Gafur on 20/9/21.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct AudioLocation : Codable {
    var id = UUID()
    let location:GeoPoint
    let file:String
    let title:String
    let userId:String
}
