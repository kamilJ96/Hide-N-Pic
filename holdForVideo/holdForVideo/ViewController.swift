//
//  ViewController.swift
//  holdForVideo
//
//  Created by Kamil on 4/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate {
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet var holdForVideoGesture: UILongPressGestureRecognizer!
    
    
    @IBAction func holdForVideo(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            self.becomeFirstResponder()
        }
    }
    
    @IBAction func takePhoto(sender: UILongPressGestureRecognizer) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
    }
    
    override func viewDidLoad() {
        holdForVideoGesture = UILongPressGestureRecognizer(target: self, action: Selector(("handleLongPress")))
        holdForVideoGesture.minimumPressDuration = 2
        holdForVideoGesture.delegate = self
        
        cameraView.addGestureRecognizer(holdForVideoGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

