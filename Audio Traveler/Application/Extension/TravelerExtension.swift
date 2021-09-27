//
//  TravelerExtension.swift
//  Aduio Travelers
//
//  Created by Gafur on 17/9/21.
//

import Foundation
import SwiftUI


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}

public extension View {
    func alert(isPresented: Binding<Bool>,title: String,message: String? = nil,dismissButton: Alert.Button? = nil) -> some View {
        alert(isPresented: isPresented) {
            Alert(title: Text(title),
                  message: {
                    if let message = message { return Text(message) }
                    else { return nil } }(),
                  dismissButton: dismissButton)
        }
    }
    

    
    func alertEvent(isPresented: Binding<Bool>,title: String,message: String? = nil,primaryButton: Alert.Button) -> some View {

        alert(isPresented: isPresented) {
            Alert(title: Text(title),message: {
                    if let message = message { return Text(message) }
                    else { return nil } }(),
                  primaryButton: primaryButton,secondaryButton: .cancel())
        }
    }
    
    func alertVersionUpdate(isPresented: Binding<Bool>,title: String,message: String? = nil,primaryButton: Alert.Button ) -> some View {
        alert(isPresented: isPresented) {
            Alert(title: Text(title),message: {
                    if let message = message { return Text(message) }
                    else { return nil } }(),
                  dismissButton: primaryButton)
        }
        
    }
    

}
