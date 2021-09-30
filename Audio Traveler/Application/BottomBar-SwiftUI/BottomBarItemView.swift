//
//  BottomBarItemView.swift
//  BottomBar
//
//  Created by Bezhan Odinaev on 7/2/19.
//  Copyright © 2019 Bezhan Odinaev. All rights reserved.
//

import SwiftUI

public struct BottomBarItemView: View {
    @Binding var selected : Int
    public let index: Int
    public let item: BottomBarItem
    @Binding public var notiBadge: Int
    
    public var body: some View {
        VStack {
            item.icon
                .imageScale(.large)
                .foregroundColor(isSelected ? item.color : .primary)
            
           // if isSelected {
                Text(item.title)
                .foregroundColor(isSelected ? item.color : Color.black)
                    .font(.caption)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
           // }
        }
        .padding([.top,.bottom],5)
        .frame(width: 120, alignment: Alignment.center)
        .background(
            Capsule()
                .fill(isSelected ? item.color.opacity(0.2) : Color.black.opacity(0.2))
        )
        .overlay(
            
            ZStack{
                if(index == 1){
                    Circle().foregroundColor(.red)
                    Text("\(self.notiBadge)")
                        .foregroundColor(.white)
                        .font(Font.system(size: 12))
                }
                
            }
                .frame(width: 15, height: 15)
                .offset(x:45,y:-20)
                .opacity(self.notiBadge == 0 ? 0 : 1)
        )
        
        
    }
    
    var isSelected : Bool{
        selected == index
    }
    
}
