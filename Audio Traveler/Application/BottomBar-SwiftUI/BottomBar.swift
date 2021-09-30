//
//  BottomBar.swift
//  BottomBar
//
//  Created by Bezhan Odinaev on 7/2/19.
//  Copyright © 2019 Bezhan Odinaev. All rights reserved.
//

import SwiftUI

public struct BottomBar : View {
    @Binding public var selectedIndex: Int
    public let items: [BottomBarItem]
    @Binding public var notiBadge: Int
    
    public init(selectedIndex: Binding<Int>, items: [BottomBarItem],notiBadge: Binding<Int>) {
        self._selectedIndex = selectedIndex
        self.items = items
        self._notiBadge = notiBadge
    }
    
    
    public init(selectedIndex: Binding<Int>, @BarBuilder items: () -> [BottomBarItem],notiBadge:Binding<Int>){
        self = BottomBar(selectedIndex: selectedIndex,
                         items: items(),notiBadge:notiBadge)
    }
    
    
    public init(selectedIndex: Binding<Int>, item: BottomBarItem,notiBadge:Binding<Int>){
        self = BottomBar(selectedIndex: selectedIndex,
                         items: [item],notiBadge: notiBadge)
    }
    
    
    func itemView(at index: Int) -> some View {
        Button(action: {
            withAnimation { self.selectedIndex = index }
        }) {
            BottomBarItemView(selected: self.$selectedIndex,
                              index: index,
                              item: items[index],notiBadge: self.$notiBadge)
        }
    }
    
    public var body: some View {
        HStack(alignment: .bottom) {
            ForEach(0..<items.count) { index in
                self.itemView(at: index)
                
                if index != self.items.count-1 {
                    Spacer()
                }
            }
        }
        .animation(.default)
    }
}

#if DEBUG
struct BottomBar_Previews : PreviewProvider {
    static var previews: some View {
        BottomBar(selectedIndex: .constant(0), items: [
            BottomBarItem(icon: "house.fill", title: "Home", color: .purple),
            BottomBarItem(icon: "heart", title: "Likes", color: .pink),
            BottomBarItem(icon: "magnifyingglass", title: "Search", color: .orange),
            BottomBarItem(icon: "person.fill", title: "Profile", color: .blue)
        ], notiBadge: .constant(1))
    }
}
#endif
