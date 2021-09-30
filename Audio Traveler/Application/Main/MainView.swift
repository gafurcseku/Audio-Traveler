//
//  MainView.swift
//  Audio Traveler
//
//  Created by Gafur on 18/9/21.
//

import SwiftUI
import GoogleMaps

struct MainView: View {
    @Binding var badgeCount:Int
    @StateObject var viewModel = TravelerAudioRecorder()
    @State var showRecordButton:CGFloat = 0
    @State var stopRecord:Bool = false
    
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    
    @State var timer: Timer? = nil
    @State var audioList:[AudioLocation] = []
    @State var location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00)
    @State var showPlay = false
    @State var selectedMarker:AudioLocation? = nil
   
    
    var body: some View {
        LoadingView(isShowing: .constant(viewModel.isLoading)){
            VStack {
                ZStack(alignment: .bottom) {
                    GoogleMapsView(audioList:self.$audioList){ (didTap,location, markerId) in
                        if let id = markerId {
                            if let position = audioList.firstIndex(where: {$0.id.uuidString == id}) {
                                self.selectedMarker = audioList[position]
                                showPlay = true
                            }
                        }else{
                            self.showRecordButton = 60
                            self.location = location
                        }
                        
                    }.edgesIgnoringSafeArea(.top)
                    
                    Button(action: {
                        viewModel.startRecording()
                        startTimer()
                    }, label: {
                        Image(systemName: "circle.circle.fill").resizable().frame(width: showRecordButton, height: showRecordButton, alignment: .center).foregroundColor(.red)
                    }).padding(.bottom, 30)
                    
                    
                }
                .bottomSheet(isPresented: .constant(viewModel.isRecording), height: 200) {
                    RecordView(fileName:.constant(viewModel.fileName), showRecordButton:self.$showRecordButton,time: "\(hours):\(minutes).\(seconds)") { (isSucess,name) in
                        if isSucess {
                            var title = ""
                            if(name.isEmpty){
                                title = viewModel.fileName
                            }else {
                                title = name
                            }
                            viewModel.stopRecording(location: self.location, title: title){ audio in
                                audioList.append(audio)
                                self.badgeCount += 1
                            }
                            stopTimer()
                        }
                    }
                }
                .bottomSheet(isPresented: self.$showPlay, height: 200, showTopIndicator: true) {
                    if let marker = self.selectedMarker {
                        TravelAudioPlayView(title:marker.title, url: marker.file, showPlayer: self.$showPlay)
                    }
                    
                }
                
               
                
            }
            .onAppear {
                viewModel.getAllAudio(userId: Helper.userID){ list in
                    self.audioList = list
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            print(tempTimer)
            if self.seconds == 59 {
                self.seconds = 0
                if self.minutes == 59 {
                    self.minutes = 0
                    self.hours = self.hours + 1
                } else {
                    self.minutes = self.minutes + 1
                }
            } else {
                self.seconds = self.seconds + 1
            }
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
        self.hours = 0
        self.minutes = 0
        self.seconds = 0
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(badgeCount: .constant(0))
    }
}
