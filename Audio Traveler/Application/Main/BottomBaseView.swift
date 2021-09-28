//
//  BottomBaseView.swift
//  Audio Traveler
//
//  Created by Gafur on 28/9/21.
//

import SwiftUI

struct BottomBaseView: View {
    @State var selectedIndex:Int = 0
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    var body: some View {
        VStack{
            if(self.selectedIndex == 0) {
                MainView()
            }else if(self.selectedIndex == 1) {
                Text("Notification")
            }else if(self.selectedIndex == 2) {
                Text("Logout")
                    .onAppear {
                        Helper.setLoggedIn(to: false)
                        self.presentationMode.wrappedValue.dismiss()
                        print(Helper.isLoggedIn)
                    }
                
            }
            Spacer()
            BottomBarView(selectedIndex: self.$selectedIndex)
        }
    }
}

struct BottomBaseView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBaseView()
    }
}
