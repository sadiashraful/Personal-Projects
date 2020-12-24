//
//  ViewController.swift
//  SmartCamera
//
//  Created by Sadi Ashraful on 19/03/2018.
//  Copyright © 2018 Sadi Ashraful. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video)
            else { return }
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice)
            else { return }
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        captureSession.addOutput(dataOutput)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        guard let model = try? VNCoreMLModel(for: Resnet50().model)
            else {return}
        let request = VNCoreMLRequest(model: model) { (finishedReq, error) in
            guard let results = finishedReq.results as? [VNClassificationObservation]
                else { return }
            guard let firstObservation = results.first else {return}
            print(firstObservation.identifier, (firstObservation.confidence) * 100)
            self.label.text = "\(firstObservation.identifier), \(firstObservation.confidence)"
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }


}

