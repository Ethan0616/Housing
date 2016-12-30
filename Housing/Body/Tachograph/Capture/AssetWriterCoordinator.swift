//
//  AssetWriterCoordinator.swift
//  Tachograph
//
//  Created by Ethan on 16/5/21.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation

// internal state machine

private enum WriterStatus : Int{
    case idle // 闲置
    case preparingToRecord  // 准备记录
    case recording          // 记录中
    case finishingRecordingPart1  // 等待追加缓存
    case finishingRecordingPart2  // 完成写入
    case finished // 终端状态
    case failed   // 终端状态
}



class AssetWriterCoordinator: NSObject {
    weak var delegate : AssetWriterCoordinatorDelegate?
    var url : URL!
    fileprivate var status : WriterStatus = .idle
    fileprivate var writingQueue : DispatchQueue!
    fileprivate var delegateCallbackQueue : DispatchQueue!
    fileprivate var assetWriter : AVAssetWriter!
    fileprivate var haveStartedSession : Bool = false
    
    // audio
    fileprivate var audioTrackSourceFormatDescription : CMFormatDescription!
    fileprivate var audioTrackSettings : [String : AnyObject] = [:]
    fileprivate var audioInput : AVAssetWriterInput!
    // video
    fileprivate var videoTrackSourceFormatDescription : CMFormatDescription!
    fileprivate var videoTrackTransform : CGAffineTransform!
    fileprivate var videoTrackSettings : [String : AnyObject] = [:]
    fileprivate var videoInput : AVAssetWriterInput?
    
    
    override init() {
        super.init()
        writingQueue = DispatchQueue(label: "org.xmyy.assetwriter.writing", attributes: [])
        videoTrackTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: External methods
extension AssetWriterCoordinator{
    
    func setURL(_ url : URL){
        self.url = url
    }
    
    func setDelegate<T : AssetWriterCoordinatorDelegate>(_ delegate : T , callbackQueue : DispatchQueue){
        
        objc_sync_enter(self)
        
        self.delegate = delegate
        
        self.delegateCallbackQueue = callbackQueue
        
        objc_sync_exit(self)
    }
    
    func addVideoTrackWithSourceFormatDescription(_ formatDescription : CMFormatDescription,videoSettings : NSDictionary){
        
        objc_sync_enter(self)
        if status != .idle {
            MSGLog(Message: "非闲置状态")
            return
        }
        videoTrackSourceFormatDescription = formatDescription
        videoTrackSettings = videoSettings as! [String : AnyObject]
        
        objc_sync_exit(self)

    }
    
    func addAudioTrackWithSourceFormatDescription(_ formatDescription : CMFormatDescription,audioSettings : NSDictionary){
        
        objc_sync_enter(self)
        
        if status != .idle {
            MSGLog(Message: "非闲置状态")
            return
        }
        
        audioTrackSourceFormatDescription = formatDescription
        audioTrackSettings = audioSettings as! [String : AnyObject]
        
        objc_sync_exit(self)
        
    }
    
    func appendVideoSampleBuffer(_ sampleBuffer : CMSampleBuffer){
        appendSampleBuffer(sampleBuffer, mediaType: AVMediaTypeVideo as NSString)
    }
    
    func appendAudioSampleBuffer(_ sampleBuffer : CMSampleBuffer){
        appendSampleBuffer(sampleBuffer, mediaType: AVMediaTypeAudio as NSString)

    }
    
    func prepareToRecord(){
        
        objc_sync_enter(self)
        
        if status != .idle {
            MSGLog(Message: "非闲置状态")
            return
        }
        
        var error : NSError? = cannotSetupInputError()

        transitionToStatus(.preparingToRecord, error: error!)
        
        objc_sync_exit(self)

        DispatchQueue.global().async {

            error = nil

            // AVAssetWriter will not write over an existing file.
            do{
                try Foundation.FileManager.default.removeItem(at: self.url)
                do{
                    try self.assetWriter = AVAssetWriter.init(outputURL: self.url, fileType: AVFileTypeQuickTimeMovie)
                    
                    self.setupAssetWriterVideoInputWithSourceFormatDescription(self.videoTrackSourceFormatDescription, transform: self.videoTrackTransform, videoSettings: &self.videoTrackSettings, errorOut: &error!)
                    self.setupAssetWriterAudioInputWithSourceFormatDescription(self.audioTrackSourceFormatDescription, audioSettings: &self.audioTrackSettings , errorOut: &error!)
                    let  success : Bool = self.assetWriter.startWriting()
                    if !success{
                        error  = self.assetWriter.error as NSError?
                    }
                }catch{
                    
                }
            }catch{
                
            }
            
            objc_sync_enter(self)
            if error != nil{
                self.transitionToStatus(.failed, error: error!)
            }else{
                self.transitionToStatus(.recording, error: nil)
            }
            objc_sync_exit(self)
            
        }
    }
    
    func finishRecording(){
        
        objc_sync_enter(self)
        var shouldFinishRecording : Bool = false
        switch  status {
        case .failed:
        // From the client's perspective the movie recorder can asynchronously transition to an error state as the result of an append.
        // Because of this we are lenient when finishRecording is called and we are in an error state.
            MSGLog(Message: "Recording has failed, nothing to do!")
            
        case .recording:
            shouldFinishRecording = true

        default:
            break
        }
        
        if shouldFinishRecording {
            transitionToStatus(.finishingRecordingPart1, error: nil)
        }else{
            return
        }
        
        objc_sync_exit(self)
        
        
        writingQueue.async { 
            
            objc_sync_enter(self)
            // We may have transitioned to an error state as we appended inflight buffers. In that case there is nothing to do now.
            if self.status != .finishingRecordingPart1{
                return
            }
            
            // It is not safe to call -[AVAssetWriter finishWriting*] concurrently with -[AVAssetWriterInput appendSampleBuffer:]
            // We transition to MovieRecorderStatusFinishingRecordingPart2 while on _writingQueue, which guarantees that no more buffers will be appended.
            
            self.transitionToStatus(.finishingRecordingPart2, error: nil)
            
            
            objc_sync_exit(self)
            
            self.assetWriter.finishWriting(completionHandler: { 
                objc_sync_enter(self)
                let error : NSError? = self.assetWriter.error as NSError?
                if let err = error{
                    self.transitionToStatus(.failed, error:err)
                }else{
                    self.transitionToStatus(.finished, error: nil)
                }
                
                objc_sync_exit(self)
            })
        }
    }
    
}

// MARK: Private methods
private extension AssetWriterCoordinator{
    @discardableResult
    func setupAssetWriterAudioInputWithSourceFormatDescription(_ audioFormatDescription : CMFormatDescription ,audioSettings : inout [String : AnyObject] , errorOut : inout NSError) -> Bool {
        audioSettings = [AVFormatIDKey : NSNumber.init(value: kAudioFormatMPEG4AAC as UInt32)]
        
        if assetWriter.canApply( outputSettings: audioSettings , forMediaType:AVMediaTypeAudio) {
            audioInput = AVAssetWriterInput(mediaType: AVMediaTypeAudio , outputSettings: audioSettings  ,sourceFormatHint: audioFormatDescription)
            audioInput.expectsMediaDataInRealTime = true
            
            
            if assetWriter.canAdd(audioInput){
                assetWriter.add(audioInput)
                return true
            }else{
                errorOut = cannotSetupInputError()
                return false
            }
        }else{
            errorOut = cannotSetupInputError()
            return false
        }
    }
    @discardableResult
    func setupAssetWriterVideoInputWithSourceFormatDescription(_ videoFormatDescription : CMFormatDescription , transform : CGAffineTransform ,videoSettings : inout [String : AnyObject],errorOut : inout NSError ) -> Bool {
        videoSettings = fallbackVideoSettingsForSourceFormatDescription(videoFormatDescription) as! [String : AnyObject]
        
        if assetWriter.canApply(outputSettings: videoSettings, forMediaType: AVMediaTypeVideo) {
            videoInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo , outputSettings:videoSettings , sourceFormatHint:videoFormatDescription)
            
            videoInput?.expectsMediaDataInRealTime = true
            videoInput?.transform = transform
            
            if assetWriter.canAdd(videoInput!){
                assetWriter.add(videoInput!)
                return true
            }else{
                errorOut = cannotSetupInputError()
                return false
            }
        }else{
            errorOut = cannotSetupInputError()
            return false
        }
    }
    
    func fallbackVideoSettingsForSourceFormatDescription(_ videoFormatDescription : CMFormatDescription) -> NSDictionary{
        var bitsPerPixel : Float!
        let dimensions : CMVideoDimensions = CMVideoFormatDescriptionGetDimensions(videoFormatDescription)
        let numPixels : Int = Int( dimensions.width * dimensions.height)
        var bitsPerSecond : Int!
        
        // Assume that lower-than-SD resolutions are intended for streaming, and use a lower bitrate
        if numPixels < (640 * 480) {
            bitsPerPixel = 4.05 // This bitrate approximately matches the quality produced by AVCaptureSessionPresetMedium or Low.
        }else{
            bitsPerPixel = 10.1  // This bitrate approximately matches the quality produced by AVCaptureSessionPresetHigh.
        }
        
        bitsPerSecond = numPixels * Int(bitsPerPixel)
        
        let compressionProperties : NSDictionary = [AVVideoAverageBitRateKey:NSNumber.init(value: bitsPerSecond as Int),AVVideoExpectedSourceFrameRateKey:NSNumber.init(value: 30 as Int),AVVideoMaxKeyFrameIntervalKey:NSNumber.init(value: 30 as Int)]
        
        return [AVVideoCodecKey:AVVideoCodecH264 , AVVideoWidthKey : NSNumber.init(value: dimensions.width as Int32) ,AVVideoHeightKey:NSNumber.init(value: dimensions.height as Int32),AVVideoCompressionPropertiesKey:compressionProperties]

    }
    
    func appendSampleBuffer(_ sampleBuffer : CMSampleBuffer, mediaType : NSString){
        
        objc_sync_enter(self)

        if status == .idle || status == .preparingToRecord {
            MSGLog(Message: "Not ready to record yet")
            return
        }
        
        
        objc_sync_exit(self)
        
        writingQueue.async {
            
            objc_sync_enter(self)
            
            // From the client's perspective the movie recorder can asynchronously transition to an error state as the result of an append.
            // Because of this we are lenient when samples are appended and we are no longer recording.
            // Instead of throwing an exception we just release the sample buffers and return.
            
            if self.status == .finishingRecordingPart2  || self.status == .finished || self.status == .failed{
                MSGLog(Message: "录制完成，不能继续追加")
                return
            }
            
            objc_sync_exit(self)
            
            if !self.haveStartedSession && mediaType as String == AVMediaTypeVideo{
                self.assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                self.haveStartedSession = true
            }
            
            let input : AVAssetWriterInput!
            if mediaType as String == AVMediaTypeVideo{
                input = self.videoInput
            }else{
                input = self.audioInput
            }
            
            if input.isReadyForMoreMediaData{
                
                let succec : Bool = input.append(sampleBuffer)
                
                if !succec{
                    
                    let error : NSError? = self.assetWriter.error as NSError?
                    
                    if let newError = error{
                        objc_sync_enter(self)
                        self.transitionToStatus(.failed, error: newError)
                        objc_sync_exit(self)
                    }
                    
                }else{
                    MSGLog(Message: "\(mediaType) input not ready for more media data, dropping buffer")
                }
            }
            
        }
    }
    
    func transitionToStatus(_ newStatus : WriterStatus , error : NSError?){
        
        var shouldNotifyDelegate : Bool = false
        if  newStatus != status {
            
            // terminal states
            if newStatus == .finished || newStatus == .failed {
                shouldNotifyDelegate = true
                // make sure there are no more sample buffers in flight before we tear down the asset writer and inputs
                writingQueue.async(execute: { 
                    
                    self.assetWriter = nil
                    self.audioInput = nil
                    self.videoInput = nil
                    if newStatus == .failed{
                        do{
                           try  Foundation.FileManager.default.removeItem(at: self.url)
                        }catch {
                            
                        }
                    }else if newStatus == .recording {
                       shouldNotifyDelegate = true
                    }
                    self.status = newStatus
                })
            }
            
            
            if shouldNotifyDelegate && self.delegate != nil {
                delegateCallbackQueue.async(execute: {
                    switch newStatus{
                        
                    case .recording:
                        self.delegate?.writerCoordinatorDidFinishPreparing(self)
                    case .finished:
                        self.delegate?.writerCoordinatorDidFinishRecording(self)
                    case .failed:
                        self.delegate?.writerCoordinatorDidFail(self, error: error!)
                    default:
                        break
                    }
                })
            }
        }
    }
    
    func cannotSetupInputError() -> NSError{
        
        let localizedDescription = "Recording cannot be started"
        let localizedFailureReason = "Cannot setup asset writer input."
        
        let errorDict = [NSLocalizedDescriptionKey : localizedDescription,NSLocalizedFailureReasonErrorKey : localizedFailureReason]
        return NSError(domain: "org.xmyy" , code: 0 ,userInfo:  errorDict)
    }
}

@objc protocol AssetWriterCoordinatorDelegate : NSObjectProtocol{
    
    func writerCoordinatorDidFinishPreparing(_ coordinator : AssetWriterCoordinator)
    func writerCoordinatorDidFinishRecording(_ coordinator : AssetWriterCoordinator)
    func writerCoordinatorDidFail(_ coordinator : AssetWriterCoordinator , error : NSError)
    
}

