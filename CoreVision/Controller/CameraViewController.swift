//
//  ViewController.swift
//  CoreVision
//
//  Created by Avijeet Sachdev on 7/30/17.
//  Copyright © 2017 Avijeet Sachdev. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var flashControl: Flash = .off
    var photoData: Data?
    
    @IBOutlet weak var captureImageView: RoundedShadowImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet var roundedLabelView: RoundedShadowView!
    @IBOutlet weak var flashButton: RoundedShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraView.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            let input = try AVCaptureDeviceInput(device: backCamera!)
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
            }
            cameraOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddOutput(cameraOutput) {
                captureSession.addOutput(cameraOutput!)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                
                cameraView.layer.addSublayer(previewLayer!)
                captureSession.startRunning()
            }
        }
        catch {
            debugPrint(error)
        }
    }
    
    func resultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else { return }
        
        for classification in results {
            
            // unknown object found
            if classification.confidence < 0.5 {
                print(classification.identifier)
                let unknownObjectMessage = "I'm not sure what this is. Please try again."
                self.identificationLabel.text = unknownObjectMessage
                self.confidenceLabel.text = ""
                break
            }
            
            // found object with confidence
            else {
                let identification = classification.identifier
                let confidence = Int(classification.confidence * 100)
                self.identificationLabel.text = identification
                self.confidenceLabel.text = "CONFIDENCE: \(confidence)%"
                let completeSentence = "This looks like a \(identification) and I'm \(confidence) percent sure."
                break
            }
        }
    }
    
    @IBAction func flashPressed(_ sender: Any) {
        switch flashControl {
        case .on:
            flashButton.setTitle("Flash Off", for: .normal)
            flashControl = .off
        case .off:
            flashButton.setTitle("Flash On", for: .normal)
            flashControl = .on
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        }
        else {
            photoData = photo.fileDataRepresentation()
            
            do {
                let model = try VNCoreMLModel(for: SqueezeNet().model)
                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)
                let handler = VNImageRequestHandler(data: photoData!)
                try handler.perform([request])
                
            }
            catch {
                debugPrint(error)
            }
            
            let image = UIImage(data: photoData!)
            self.captureImageView.image = image
        }
    }
}
