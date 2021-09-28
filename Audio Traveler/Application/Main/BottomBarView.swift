//
//  BottomBarView.swift
//  Audio Traveler
//
//  Created by Gafur on 19/9/21.
//

import SwiftUI

struct BottomBarView: View {
    @Binding var selectedIndex:Int
    
    let items: [BottomBarItem] = [
        BottomBarItem(icon: "house.fill", title: "Home", color: .purple),
        BottomBarItem(icon: "bookmark.fill", title: "Notification", color: .pink),
        BottomBarItem(icon: "arrow.down.left.circle.fill", title: "Log out", color: .orange)
        ]
    
    var body: some View {
        BottomBar(selectedIndex: $selectedIndex, items: items)
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(selectedIndex: Binding<Int>.constant(0))
    }
}
