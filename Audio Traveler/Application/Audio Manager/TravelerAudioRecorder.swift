//
//  TravelerAudioRecorder.swift
//  Audio Traveler
//
//  Created by Gafur on 18/9/21.
//

import AVFoundation
import Foundation
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
import GoogleMaps


class TravelerAudioRecorder: ObservableObject{
    @Published var isLoading:Bool = false
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    @Published var isRecording : Bool = false
    @Published var fileName:String = ""
    @Published var showPlay = false
    
    var timer: Timer? = nil
    
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    var audioFileUrl:String = ""
    
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Can not setup the Recording")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a"
        let audioFilename = documentPath.appendingPathComponent(fileName)
        self.audioFileUrl = audioFilename.absoluteString
        self.fileName = fileName.replacingOccurrences(of: ".m4a", with: "")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            isRecording = true
        } catch {
            print("Failed to Setup the Recording")
        }
    }
    
    func stopRecording(location:CLLocationCoordinate2D, title:String,complete:@escaping (AudioLocation) -> Void) {
        isLoading = true
        audioRecorder.stop()
        isRecording = false
        uploadAudioFile(url: audioFileUrl) { [self] downloadUrl in
            print(downloadUrl as Any)
            let audioRef =  db.collection(Constansts.AUDIOFILE)
            let notification = db.collection(Constansts.NOTIFICATION)
            let audio = AudioLocation(location: GeoPoint(latitude: location.latitude, longitude: location.longitude), file: downloadUrl ?? "", title: title, userId: Helper.userID)
            
            let notify = Notification(date: Date().toString(dateFormat: "dd MMM yyyy, hh:mm"), title: title, status: false)
            do{
                _ = try audioRef.addDocument(from: audio)
                _ = try notification.addDocument(from: notify)
                complete(audio)
                isLoading = false
            }catch let error {
                isLoading = false
                print("Error writing User to Firestore: \(error)")
                
            }
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            
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
    }
    
    private func uploadAudioFile(url: String,  block: @escaping (_ url: String?) -> Void){
        guard let fileUrl = URL(string: url) else {
            return
        }
        let fileName = NSUUID().uuidString + ".m4a"
        storage.reference().child(fileName).putFile(from: fileUrl, metadata: nil) { (metaData, error) in
            guard metaData != nil else {
                block(nil)
                return
            }
            
            self.storage.reference().child(fileName).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    block(nil)
                    return
                }
                block(downloadURL.absoluteString)
            }
        }
    }
    
    @Published var audioList = [AudioLocation]()
    
    func getAllAudio(userId:String,complete:@escaping ([AudioLocation]) -> Void){
        isLoading = true
        db.collection(Constansts.AUDIOFILE)
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (querySnapshot, err) in
                if let error = err {
                    self.isLoading = false
                    print("Error getting Audio List: \(error)")
                }else {
                    var list = [AudioLocation]()
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let audiobject = Result {
                            try document.data(as: AudioLocation.self)
                        }
                        switch audiobject {
                        case .success(let audioList):
                            if let audio = audioList {
                                print("Audio Model: \(audio)")
                                list.append(audio)
                            }
                        case .failure(let error):
                            print("Error decoding audio: \(error)")
                        }
                    }
                    self.isLoading = false
                    complete(list)
                    
                }
            }
    }
    
    
    
    @Published var player = AVAudioPlayer()
    
    func startPlaying(url:String ,del:AVdelegate) {
        self.isLoading = true
        guard let url = URL(string: url) else {
            print("Invalid URL")
            self.isLoading = false
            return
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playback)
            let soundData = try Data(contentsOf: url)
            player = try AVAudioPlayer(data: soundData)
            player.prepareToPlay()
            player.volume = 0.7
            player.delegate = del
            self.isLoading = false
            //  let minuteString = String(format: "%02d", (Int(player.duration) / 60))
            //  let secondString = String(format: "%02d", (Int(player.duration) % 60))
            //   print("TOTAL TIMER: \(minuteString):\(secondString)")
        } catch {
            self.isLoading = false
            print(error)
        }
        
        if player.isPlaying {
            player.pause()
        }
        else {
            player.play()
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
       
    }
    
    func stopPlaying(){
        audioPlayer.stop()
    }
    
    
}



