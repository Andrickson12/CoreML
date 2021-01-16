//
//  ViewController.swift
//  seeFood
//
//  Created by Andrickson Coste on 1/8/21.
//  Copyright © 2021 Qalab Inc. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Properties
    @IBOutlet weak var imageViewCheck: UIImageView!
    
    //Object from UIImagePickerController Class
    let imagePicker = UIImagePickerController()
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting its delegate
        imagePicker.delegate = self
        
        //Setting some properties
        imagePicker.allowsEditing = false
        
    }
    
    //Delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        /*info parameter contains the image that user took*/
        
        //Getting the user picture with dowcasting and optional binding
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //Presenting user's image in imageView
            imageViewCheck.image = userPickedImage
            
            //Coverting user picked image into a CI image [Core Image image]
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciimage)
        }
        //Dismissing image picker
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //Method to process the CIImage and get interpretation out of it
    func detect(image: CIImage) {
        //Using inceptionV3 model; Loading the model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML model failed.")
        }
        //Using the model to make a request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            //Process the result of this request
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            //Just printing results property
            print(results)
        }
        //Specifying which image to classify; which is the image parameter in this func
        let handler = VNImageRequestHandler(ciImage: image)
        //Using handler to perform the request; using do-catch block for safer code
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        //Pesenting camera
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true , completion: nil)
    }
    
    @IBAction func albumTapped(_ sender: UIBarButtonItem) {
        
        //Pesenting album
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}
