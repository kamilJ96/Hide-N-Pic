//
//  EndGameImageViewController.swift
//  Hide&PicFromScratch
//
//  Created by Leonard Zou on 17/10/17.
//  Copyright © 2017 VanillaThunder. All rights reserved.
//

import UIKit

// displays the image taken by the user from the AR View
class EndGameImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var endGameImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.contentMode = .scaleAspectFit
        imageView.image = endGameImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
