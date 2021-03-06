//
//  AVTonePlayerUnit.swift
//  Sonify
//
//  Created by OOPer in cooperation with shlab.jp, on 2015/3/22.
//  See LICENSE.txt .
//  taken from: https://github.com/ooper-shlab/ToneGenerator1.0-Swift/blob/master/ToneGenerator/AVTonePlayerUnit.swift

import Foundation
import AVFoundation

class AVTonePlayerUnit: AVAudioPlayerNode {
    
    //setup for the audio
    let bufferCapacity: AVAudioFrameCount = 512
    let sampleRate: Double = 44_100.0
    
    var frequency: Double = 440.0
    var amplitude: Double = 0.25
    
    private var theta: Double = 0.0
    private var audioFormat: AVAudioFormat!
    
    override init() {
        super.init()
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)
    }
    
    func prepareBuffer() -> AVAudioPCMBuffer {
        let buffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: bufferCapacity)
        fillBuffer(buffer)
        return buffer
    }
    
    func fillBuffer(buffer: AVAudioPCMBuffer) {
        let data = buffer.floatChannelData[0]
        let numberFrames = buffer.frameCapacity
        var theta = self.theta
        let theta_increment = 2.0 * M_PI * self.frequency / self.sampleRate
        
        for frame in 0..<Int(numberFrames) {
            data[frame] = Float32(sin(theta) * amplitude)
            
            theta += theta_increment
            if theta > 2.0 * M_PI {
                theta -= 2.0 * M_PI
            }
        }
        buffer.frameLength = numberFrames
        self.theta = theta
    }
    
    func scheduleBuffer() {
        let buffer = prepareBuffer()
        self.scheduleBuffer(buffer) {
            if self.playing {
                self.scheduleBuffer()
            }
        }
    }
    
    func preparePlaying() {
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
    }
}