//
//  RecordView.swift
//  Audio Traveler
//
//  Created by Gafur on 18/9/21.
//

import SwiftUI



struct RecordView: View {
    @Binding var fileName:String
    @Binding var showRecordButton:CGFloat
    @State var name:String = ""
    var time:String = ""
    var stopRecord:(Bool,String) -> Void
    var body: some View {
        VStack{
            TextField(fileName, text: self.$name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text(time)
                .padding([.top,.bottom],15)
            Button(action: {
                self.showRecordButton = 0
                stopRecord(true,name)
                self.name = ""
            }, label: {
                Image(systemName: "square.circle.fill").resizable().frame(width: 60, height: 60, alignment: .center).foregroundColor(.red)
            })
            
        }.padding([.leading,.trailing], 25)
        
    }
    
    
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(fileName: .constant("sample Name"), showRecordButton: .constant(0)){ (a ,v)  in
            
        }
    }
}
