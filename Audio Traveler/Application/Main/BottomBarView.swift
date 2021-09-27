//
//  BottomBarView.swift
//  Audio Traveler
//
//  Created by Gafur on 19/9/21.
//

import SwiftUI

struct BottomBarView: View {
    @State var selectedIndex:Int = 0
    
    var body: some View {
        GeometryReader { geo in
           
                HStack {
                    Button(action: {
                        self.selectedIndex = 0
                    }, label: {
                        Image(systemName: "house.fill").resizable().frame(width: 40, height: 40, alignment: .center)
                            .foregroundColor(selectedIndex == 0 ? .white : .blue)
                    })
                    .frame(width: geo.size.width/3, height: geo.size.height)
                    .background(selectedIndex == 0 ? Color.black : Color.white)
                    
                    Button(action: {
                        self.selectedIndex = 1
                    }, label: {
                        Image(systemName: "bookmark.fill").resizable().frame(width: 40, height: 40, alignment: .center)
                            .foregroundColor(selectedIndex == 1 ? .white : .blue)
                    })
                    .frame(width: geo.size.width/3,height: geo.size.height)
                    .background(selectedIndex == 1 ? Color.black : Color.white)
                    
                    Button(action: {
                        self.selectedIndex = 2
                    }, label: {
                        Text("Logout")
                            .foregroundColor(selectedIndex == 2 ? .white : .blue)
                    })
                    .frame(width: geo.size.width/3,height: geo.size.height)
                    .background(selectedIndex == 2 ? Color.black : Color.white)
                }
          
        }
        .frame(height: 60, alignment: .center)
        .background(Color.white)
        
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView()
    }
}
