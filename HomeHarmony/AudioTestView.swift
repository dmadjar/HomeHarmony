//
//  AudioTestView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 4/11/24.
//

import SwiftUI
import FirebaseStorage
import AVKit

struct AudioTestView: View {
    @State var record = false
    @State var session : AVAudioSession!
    @State var recorder : AVAudioRecorder!
    @State var alert = false
    
    var body: some View {
        VStack {
            Button {
                do {
                    
                    if self.record{
                        
                        // Already Started Recording means stopping and saving...
                        
                        self.recorder.stop()
                        self.record.toggle()
                        // updating data for every rcd...
                        return
                    }
                    
                    let filName = URL(filePath: "myRcd.m4a")
                                            
                    let settings = [
                    
                        AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey : 12000,
                        AVNumberOfChannelsKey : 1,
                        AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
                    
                    ]
                    
                    self.recorder = try AVAudioRecorder(url: filName, settings: settings)
                    self.recorder.record()
                    self.record.toggle()
                } catch {
                    
                }
            } label: {
                ZStack {
                    if record {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(Color("textColor"))
                    }
                    
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color("redColor"))
                }
            }
        }
        .alert(isPresented: self.$alert, content: {
                Alert(title: Text("Error"), message: Text("Enable Access."))
        })
        .onAppear {
            do {
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                
                self.session.requestRecordPermission { (status) in
                    if !status {
                        self.alert.toggle()
                    } else {
                        
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

#Preview {
    AudioTestView()
}
