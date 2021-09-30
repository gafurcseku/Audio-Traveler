//
//  Notification.swift
//  Audio Traveler
//
//  Created by Gafur on 28/9/21.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Notification : Codable {
    var id = UUID()
    let date:String
    let title:String
    let status:Bool
    var documentId:String?
}

extension Notification {
    var getDocumentId:String {
        guard let documentId = self.documentId  else {
            return ""
        }
        return documentId
    }
}
