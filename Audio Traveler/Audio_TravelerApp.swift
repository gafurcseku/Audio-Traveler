//
//  Audio_TravelerApp.swift
//  Audio Traveler
//
//  Created by Gafur on 18/9/21.
//

import SwiftUI
import Firebase
import GoogleMaps

@main
struct Audio_TravelerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginAccountUIView()
        }
    }
}

class AppDelegate: NSObject , UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyBViGPZNFcUWiNl5Y6E4oAHe1uJ2IBmWao")
        return true
    }
}
