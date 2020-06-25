//
//  CaptureSessionAssetWriterCoordinator.swift
//  Tachograph
//
//  Created by Ethan on 16/5/21.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation


enum RecordingStatus : Int {
    case idle = 0
    case startingRecording
    case recording
    case stoppingRecording
}



class CaptureSessionAssetWriterCoordinator: CaptureSessionCoordinator {

    var videoDataOutputQueue : DispatchQueue!
    var audioDataOutputQueue : DispatchQueue!
    
    var videoDataOutput : AVCaptureVideoDataOutput!
    var audioDataOutput : AVCaptureAudioDataOutput!
    
    var videoConnection : AVCaptureConnection!
    var audioConnection : AVCaptureConnection!
    
    var videoCompressionSettings : [String : AnyObject]!
    var audioCompressionSettings : [String : AnyObject]!
    
    var outputVideoFormatDescription : CMFormatDescription!
    var outputAudioFormatDescription : CMFormatDescription!
    
    var assetWriter : AVAssetWriter!
    
    var recordingStatus : RecordingStatus = .idle
    
    var recordingURL : URL!
    
    var assetWriterCoordinator : AssetWriterCoordinator!
    
    
    override init() {
        super.init()
        videoDataOutputQueue = DispatchQueue(label: "org.xmyy.capturesession.videodata", attributes: [])
        videoDataOutputQueue.setTarget(queue: DispatchQueue.global())
        
        audioDataOutputQueue = DispatchQueue(label: "org.xmyy.capturesession.audiodata", attributes: [])
        
        addDataOutputsToCaptureSession(captureSession)
    }
    
    override func startRecording() {
        objc_sync_enter(self)
        if recordingStatus != .idle {
            MSGLog(Message: "Already recording")
            return
        }
        
        var error : NSError?
        
        transitionToRecordingStatus( .startingRecording, error: &error)
        
        objc_sync_exit(self)
        
        recordingURL = FileManager.createFileUrl() as URL?
        assetWriterCoordinator = AssetWriterCoordinator()
        assetWriterCoordinator.url = recordingURL
        if outputAudioFormatDescription != nil {
            assetWriterCoordinator.addAudioTrackWithSourceFormatDescription(outputAudioFormatDescription, audioSettings:audioCompressionSettings as NSDictionary)
            assetWriterCoordinator.addVideoTrackWithSourceFormatDescription(outputVideoFormatDescription, videoSettings: videoCompressionSettings as NSDictionary)
            
            let callbackQueue = DispatchQueue(label: "org.xmyy.capturesession.writercallback", attributes: [])
            assetWriterCoordinator.setDelegate(self, callbackQueue: callbackQueue)
            assetWriterCoordinator.prepareToRecord() // asynchronous, will call us back with recorderDidFinishPreparing: or recorder:didFailWithError: when done
            
        }
        
    }
    
    @objc override func stopRecording() {
        objc_sync_enter(self)
        if recordingStatus != .recording {
            MSGLog(Message: "nothing to do!!")
            return
        }
        var error : NSError?
        transitionToRecordingStatus(.stoppingRecording, error: &error)
        objc_sync_exit(self)
        
        assetWriterCoordinator.finishRecording()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: private methods
private extension CaptureSessionAssetWriterCoordinator{
    func transitionToRecordingStatus(_ newStatus : RecordingStatus ,error : inout NSError?){
        let oldStatus : RecordingStatus = recordingStatus
        recordingStatus = newStatus
        
        if newStatus != oldStatus {
            if  let err = error {
                if newStatus == .idle {
                    self.callBackQueue.async(execute: { 
                        
                        self.delegate?.coordinatorDidFinishRecording(self, outputFileURL: self.recordingURL, err)
                        
                    })
                }else{
                    error = nil
                    if  oldStatus == .startingRecording && newStatus == .recording {
                        self.callBackQueue.async(execute: { 
                            self.delegate?.coordinatorDidBeginRecording(self)
                        })
                    }else if oldStatus == .stoppingRecording && newStatus == .idle{
                        self.callBackQueue.async(execute: { 
                            self.delegate?.coordinatorDidFinishRecording(self, outputFileURL: self.recordingURL, err)
                        })
                    }
                }
            }
        }
    }
}
// MARK: AssetWriterCoordinatorDelegate methods
extension CaptureSessionAssetWriterCoordinator : AssetWriterCoordinatorDelegate{

    func writerCoordinatorDidFinishPreparing(_ coordinator : AssetWriterCoordinator){
        
        objc_sync_enter(self)
        
        if recordingStatus !=  .startingRecording{
            MSGLog(Message: "Expected to be in StartingRecording state")
            return
        }
        var error : NSError?
        
        transitionToRecordingStatus(.recording, error: &error)
        
        objc_sync_exit(self)
        
    }
    
    func writerCoordinatorDidFinishRecording(_ coordinator : AssetWriterCoordinator){
        
        objc_sync_enter(self)

        if recordingStatus != .stoppingRecording {
            MSGLog(Message: "Expected to be in StoppingRecording state")
            return
        }
        
        // No state transition, we are still in the process of stopping.
        // We will be stopped once we save to the assets library.
        
        objc_sync_exit(self)
        
        assetWriterCoordinator = nil
        
        objc_sync_enter(self)
        
        var error : NSError?

        transitionToRecordingStatus(.idle, error: &error)
        
        objc_sync_exit(self)
    }
    
    func writerCoordinatorDidFail(_ coordinator : AssetWriterCoordinator , error : NSError){
        objc_sync_enter(self)
        assetWriterCoordinator = nil
        var error : NSError?

        transitionToRecordingStatus(.idle, error: &error)
        
        objc_sync_exit(self)
    }
    
}

extension CaptureSessionAssetWriterCoordinator : AVCaptureVideoDataOutputSampleBufferDelegate , AVCaptureAudioDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        let formatDescription : CMFormatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)!
        
        if connection === videoConnection {
            if outputVideoFormatDescription == nil {
                
                // Don't render the first sample buffer.
                // This gives us one frame interval (33ms at 30fps) for setupVideoPipelineWithInputFormatDescription: to complete.
                // Ideally this would be done asynchronously to ensure frames don't back up on slower devices.
                
                //TODO: outputVideoFormatDescription should be updated whenever video configuration is changed (frame rate, etc.)
                //Currently we don't use the outputVideoFormatDescription in IDAssetWriterRecoredSession
                setupVideoPipelineWithInputFormatDescription(formatDescription)
            }else{
                self.outputVideoFormatDescription = formatDescription
                
                objc_sync_enter(self)
                
                if recordingStatus == .recording {
                    assetWriterCoordinator.appendVideoSampleBuffer(sampleBuffer)
                }
                
                objc_sync_exit(self)
                
            }
        }else if connection === audioConnection{
            self.outputAudioFormatDescription = formatDescription
            
            objc_sync_enter(self)
            
            if recordingStatus == .recording {
                assetWriterCoordinator.appendAudioSampleBuffer(sampleBuffer)
            }
            
            objc_sync_exit(self)
        }
    }
}

// private methods
private extension CaptureSessionAssetWriterCoordinator{
    
    func addDataOutputsToCaptureSession(_ captureSession : AVCaptureSession){
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = nil
        videoDataOutput.alwaysDiscardsLateVideoFrames = false
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        addOutput(videoDataOutput, captureSession: captureSession)
        videoConnection = videoDataOutput.connection(with: AVMediaType.video)
        
        
        audioDataOutput = AVCaptureAudioDataOutput()
        audioDataOutput.setSampleBufferDelegate(self, queue: audioDataOutputQueue)
        addOutput(audioDataOutput, captureSession: captureSession)
        audioConnection = audioDataOutput.connection(with: AVMediaType.audio)
        
        
        let videoDict = videoDataOutput.recommendedVideoSettingsForAssetWriter(writingTo: AVFileType.mov)
        let videoKey  = videoDict?.keys.first as! String
        videoCompressionSettings = [videoKey : videoDict![videoKey]! as AnyObject]
        
        
        let audioDict = audioDataOutput.recommendedAudioSettingsForAssetWriter(writingTo: AVFileType.mov)
        let audioKey  = audioDict?.keys.first as! String
        audioCompressionSettings = [audioKey : audioDict![audioKey]! as AnyObject]
    }
    
    func setupVideoPipelineWithInputFormatDescription(_ inputFormatDescription : CMFormatDescription){
        self.outputVideoFormatDescription = inputFormatDescription
    }
    
    
    func teardownVideoPipeline(){
        self.outputVideoFormatDescription = nil
    }
    
}





