//
//  ViewController.swift
//  CalorieTracker.ai
//
//  Created by Sadi Ashraful on 06/11/2018.
//  Copyright © 2018 Sadi Ashraful. All rights reserved.
//

import UIKit
import CoreML
import Vision

class FoodClassifierViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classificationLabel: UILabel!
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: BurgerModel().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                self.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML Model: \(error)")
        }
    }()
    
    func processClassifications(for request: VNRequest, error: Error?){
        DispatchQueue.main.sync {
            guard let classifications = request.results as? [VNClassificationObservation] else {
                self.classificationLabel.text = "Unable to classify image. \n\(error?.localizedDescription ?? "Error")"
                return
            }
            
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognised."
            } else {
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    return String(format: "%.2f", classification.confidence * 100) + "% - " + classification.identifier
                }
                
                self.classificationLabel.text = "Classifications:\n" + descriptions.joined(separator: "\n")
            }
        }
        
    }
    
    func updateClassifications(for image: UIImage){
        classificationLabel.text = "Classifying..."
        
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)),
            let ciImage = CIImage(image: image) else {
                displayError()
                return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func displayError(){
        classificationLabel.text = "Something went wrong... \nPlease try again."
    }


    @IBAction func cameraButtonWasPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        
        let choosenPhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhotoAction)
        photoSourcePicker.addAction(choosenPhotoAction)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true, completion: nil)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
}

extension FoodClassifierViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { fatalError("No iamge returned")}
        imageView.image = image
        updateClassifications(for: image)
    }
}

