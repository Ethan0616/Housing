//
//  CaptureSessionMovieFileOutputCoordinator.swift
//  Tachograph
//
//  Created by Ethan on 16/5/20.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary


class CaptureSessionMovieFileOutputCoordinator: CaptureSessionCoordinator, AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        
    }
    
    
    var movieFileOutput : AVCaptureMovieFileOutput!
    
    override init() {
        super.init()

        movieFileOutput = AVCaptureMovieFileOutput()
        if !addOutput(movieFileOutput, captureSession: captureSession) {
            MSGLog(Message: "movieFileOutput 添加失败 ！")
        }
    }

    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
    
    // override
    override func startRecording() {
        // 开始录制保存的路径
        let path : URL? = FileManager.createFileUrl() as URL?
        if  let  pathStr = path{
            
            self.movieFileOutput.startRecording(to: pathStr, recordingDelegate: self)
        }
    }
    
    override func stopRecording() {

        movieFileOutput.stopRecording()

    }
    
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!){
        
        self.delegate?.coordinatorDidBeginRecording(self)
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!){
        
        self.delegate?.coordinatorDidFinishRecording(self, outputFileURL: outputFileURL, error as NSError?)

    }
}
