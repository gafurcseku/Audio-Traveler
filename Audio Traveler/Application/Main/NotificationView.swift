//
//  NotificationView.swift
//  Audio Traveler
//
//  Created by Gafur on 29/9/21.
//

import SwiftUI

struct NotificationView: View {
    @Binding var selected:Int
    @StateObject var viewModel = NotificationViewModel()
    var body: some View {
        LoadingView(isShowing: .constant(viewModel.isLoading)){
            VStack{
                if(viewModel.notificationList.count >= 1){
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .center){
                            ForEach(0..<viewModel.notificationList.count, id:\.self){ index in
                                let notiObject = viewModel.notificationList[index]
                                HStack {
                                    VStack(alignment:.leading){
                                        Text(notiObject.title)
                                            .foregroundColor(Color.black)
                                            .font(.title)
                                        
                                        Text(notiObject.date)
                                            .foregroundColor(Color.gray)
                                            .font(.title3)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                                .onTapGesture {
                                    viewModel.UpdateNotficationStatus(documentId: notiObject.getDocumentId)
                                    self.selected = 0
                                }
                            }
                            
                            
                        }
                        .padding()
                    }
                }else if(viewModel.emptyNotification){
                    
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Text("No Notification yet")
                                .foregroundColor(Color.black)
                                .font(.title)
                            Text("Check Again for updates about new Travel Audio are record.")
                                .foregroundColor(Color.gray)
                                .font(.subheadline)
                                .padding(.top,2)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                }
                
                
                
                
            }
            .background(Color.white)
            .onAppear(perform: {
                viewModel.getAllNotification()
            })
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(selected: Binding<Int>.constant(0))
    }
}
