//
//  CaptureSessionCoordinator.swift
//  Tachograph
//
//  Created by Ethan on 16/5/20.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation


@objc protocol CaptureSessionCoordinatorDelegate : NSObjectProtocol{
    
    func coordinatorDidBeginRecording(_ coordinator : CaptureSessionCoordinator)
    func coordinatorDidFinishRecording(_ coordinator : CaptureSessionCoordinator , outputFileURL : URL ,_ error : NSError?)
    
}

class CaptureSessionCoordinator: NSObject {
    
    weak var delegate : CaptureSessionCoordinatorDelegate?
    var captureSession : AVCaptureSession!
    var cameraDevice : AVCaptureDevice!
    var callBackQueue : DispatchQueue!

    fileprivate var sessionQueue : DispatchQueue!
    var previewLayer : AVCaptureVideoPreviewLayer?  {
        
        get {
            if (self.captureSession != nil) {
                
                return AVCaptureVideoPreviewLayer.init(session: captureSession)
            }else{
                return nil
            }
        }
    }

    override init() {
        super.init()
        sessionQueue = DispatchQueue(label: "dispatch_queue_serial", attributes: [])
        
        captureSession = AVCaptureSession()

        do{
            let cameraDeviceInput = try
                AVCaptureDeviceInput.init(device: AVCaptureDevice.default(for: AVMediaType.video)!)
                    
                addInput(cameraDeviceInput, captureSession: captureSession)
            
        }catch let error as NSError {
            MSGLog(Message: "\(String(describing: error))")
        }
        

        do{

            let micDeviceInput = try
            AVCaptureDeviceInput.init(device:  AVCaptureDevice.default(for: AVMediaType.audio)!)
            addInput(micDeviceInput, captureSession: captureSession)
            
        }catch let error as NSError{
            MSGLog(Message: "\(error)")
        }

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegate< T : CaptureSessionCoordinatorDelegate>(_ delegate : T, callBackQueue : DispatchQueue) {
        
        objc_sync_enter(self)
        
        self.delegate = delegate
    
        self.callBackQueue = callBackQueue
        
        objc_sync_exit(self)

    }
    
    @discardableResult
    func addInput(_ input : AVCaptureDeviceInput , captureSession : AVCaptureSession) -> Bool {

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
            return true
        }else{
            return false
        }
    }
    
    @discardableResult
    func addOutput(_ output : AVCaptureOutput , captureSession : AVCaptureSession ) -> Bool {
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
            return true
        }else{
            return false
        }
    }
    
    
    func startRecording(){
        //
    }
    
    func stopRecording(){
        //
    }
    
    final func startRunning(){
        sessionQueue.sync {
            self.captureSession.startRunning()
        }
    }
    
    final func stopRunning(){
        sessionQueue.sync {
            self.stopRecording()
            self.captureSession.stopRunning()
        }
    }
    
    // Switching between front and back cameras
    fileprivate func cameraWithPosition(_ position : AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices : Array = AVCaptureDevice.devices(for: AVMediaType.video)
        for  device in devices{
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    func swapFrontAndBackCameras(){
        // Assume the session is already running
        if captureSession.isRunning {
            
            let inputs : NSArray = captureSession.inputs as NSArray
            
            for input in inputs {
                let device : AVCaptureDevice = (input as AnyObject).device
                if device.hasMediaType(AVMediaType.video) {
                    let position : AVCaptureDevice.Position = device.position
                    var newCamera : AVCaptureDevice?
                    if position == .front {
                        newCamera = cameraWithPosition(.back)
                    }else{
                        newCamera = cameraWithPosition(.front)
                    }
                    
                    if let newDevice = newCamera {
                        do{
                            let newInput : AVCaptureDeviceInput = try AVCaptureDeviceInput.init(device: newDevice)
                            captureSession.beginConfiguration()
                            captureSession.removeInput(input as! AVCaptureInput)
                            captureSession.addInput(newInput)
                            captureSession.commitConfiguration()
                        }catch{
                            MSGLog(Message: "切换摄像头时，重新初始化输入设备失败！")
                        }
                    }
                }
            }
            
            
        }else{
            MSGLog(Message: "session not running!")
        }
    }
    
    /*
     - (void)swapFrontAndBackCameras {
     
     NSArray *inputs = self.session.inputs;
     for ( AVCaptureDeviceInput *input in inputs ) {
     AVCaptureDevice *device = input.device;
     if ( [device hasMediaType:AVMediaTypeVideo] ) {
     AVCaptureDevicePosition position = device.position;
     AVCaptureDevice *newCamera = nil;
     AVCaptureDeviceInput *newInput = nil;
     
     if (position == AVCaptureDevicePositionFront)
     newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
     else
     newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
     newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
     
     // beginConfiguration ensures that pending changes are not applied immediately
     [self.session beginConfiguration];
     
     [self.session removeInput:input];
     [self.session addInput:newInput];
     
     // Changes take effect once the outermost commitConfiguration is invoked.
     [self.session commitConfiguration];
     break;
     }
     }
     }

     */
}







