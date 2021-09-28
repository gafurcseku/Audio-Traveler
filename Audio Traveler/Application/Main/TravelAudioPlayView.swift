//
//  TravelAudioPlayView.swift
//  Audio Traveler
//
//  Created by Gafur on 26/9/21.
//

import SwiftUI
import AVKit

struct TravelAudioPlayView: View {
    @StateObject var viewModel = TravelerAudioRecorder()
    @State var width : CGFloat = 0
    @State var finish = false
    @State var playing = false
    @State var del: AVdelegate? = nil
    @State var timer: Timer? = nil
    
    var title:String = ""
    var url:String = ""
    @Binding var showPlayer:Bool
    
   
    
    var body: some View {
        VStack(spacing: 20){
            Text(self.title).font(.title).padding(.top)
            HStack(spacing: UIScreen.main.bounds.width / 3 - 30){
                Button{
                    if (viewModel.player.isPlaying){
                        viewModel.player.currentTime -= 15
                    }
                    
                } label: {
                    
                    Image(systemName: "backward.fill").font(.title)
                    
                }
                Button {
                    if (self.viewModel.player.isPlaying){
                        self.viewModel.player.pause()
                        self.playing = false
                    }else{
                        if let del = self.del {
                            viewModel.startPlaying(url: self.url,del: del)
                            self.playing = true
                        }
                        
                    }
                   
                } label: {
                    Image(systemName: self.playing && !self.finish ? "pause.fill" : "play.fill").font(.title)
                }
                
                Button(action: {
                    if (viewModel.player.isPlaying){
                        viewModel.player.currentTime += 15
                    }
                }) {
            
                    Image(systemName: "forward.fill").font(.title)
                    
                }

            }
            
            ZStack(alignment: .leading) {
                Capsule().fill(Color.black.opacity(0.08)).frame(height: 8)
                Capsule().fill(Color.red).frame(width: self.width, height: 8)
                    .gesture(DragGesture()
                                .onChanged({ (value) in
                        
                        
                        self.width = value.location.x
                        
                    }).onEnded({ (value) in
                        
                        let x = value.location.x
                        
                        let screen = UIScreen.main.bounds.width - 30
                        
                        let percent = x / screen
                        
                        self.viewModel.player.currentTime = Double(percent) * self.viewModel.player.duration
                        
                    }))
            }
        }.padding()
            .onAppear {
                self.del = AVdelegate() { finish in
                    if(finish){
                        self.width = 0
                        self.timer?.invalidate()
                        self.timer = nil
                        self.showPlayer = false
                        self.finish = true
                    }
                    
                }
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tempTimer in
                    if(!self.showPlayer){
                        self.viewModel.player.stop()
                        self.width = 0
                        self.timer?.invalidate()
                        self.timer = nil
                        self.showPlayer = false
                        self.finish = true
                    }
                    if self.viewModel.player.isPlaying{
                        print("ISPLAY2")
                        let screen = UIScreen.main.bounds.width - 30
                        
                        let value = self.viewModel.player.currentTime / self.viewModel.player.duration
                        
                        self.width = screen * CGFloat(value)
                    }
                }
            }
    }
}

class AVdelegate : NSObject,AVAudioPlayerDelegate{
    
    var finish:(Bool) -> Void
     
    init(finish:@escaping (Bool) -> Void) {
        self.finish = finish
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finis Play")
        finish(true)
       // NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}

struct TravelAudioPlayView_Previews: PreviewProvider {
    static var previews: some View {
        TravelAudioPlayView(showPlayer:Binding.constant(true))
    }
}
